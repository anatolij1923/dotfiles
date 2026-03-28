pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.common

Singleton {
    id: root

    readonly property CpuStats cpu: CpuStats {}
    readonly property MemoryStats mem: MemoryStats {}
    readonly property GpuStats gpu: GpuStats {}
    readonly property NetworkStats network: NetworkStats {}
    readonly property StorageStats storage: StorageStats {}

    property string _cpuHwmonPath: ""
    property string _gpuHwmonPath: ""
    property string _gpuCardPath: ""

    component CpuStats: QtObject {
        id: cpuStats

        property real usage: 0 // 0.0-1.0
        property real temp: 0 // °C
        property real frequency: 0 // MHz
    }
    component MemoryStats: QtObject {
        id: memoryStats

        property real ramUsed: 0 // Bytes
        property real ramTotal: 0 // Bytes
        property real ramUsedPercentage: 0 // 0.0-1.0

        property real swapUsed: 0 // Bytes
        property real swapTotal: 0 // Bytes
        property real swapUsedPercentage: 0 // 0.0-1.0
    }

    component GpuStats: QtObject {
        id: gpuStats

        property real usage: 0 // 0.0-1.0
        property real temp: 0 // °C
    }

    component NetworkStats: QtObject {
        id: networkStats

        property real downloadSpeed: 0 // KB/s
        property real uploadSpeed: 0 // KB/s

    }

    component StorageStats: QtObject {
        id: storageStats

        property real used: 0 // Bytes
        property real total: 0 // Bytes
        property real usedPercentage: 0 // 0.0-1.0
    }

    FileView {
        id: cpuStatFile
        path: "/proc/stat"

        property real lastTotal: 0
        property real lastIdle: 0

        onLoaded: {
            const content = text();
            if (!content) {
                return;
            }
            let lines = content.split("\n");
            let cpuLine = lines[0];
            let parts = cpuLine.split(/\s+/);

            let user = parseInt(parts[1]);
            let nice = parseInt(parts[2]);
            let system = parseInt(parts[3]);
            let idle = parseInt(parts[4]);
            let iowait = parseInt(parts[5]);
            let irq = parseInt(parts[6]);
            let softirq = parseInt(parts[7]);
            let steal = parseInt(parts[8]);

            let currentIdle = idle + iowait;
            let currentTotal = user + nice + system + currentIdle + irq + softirq + steal;

            if (lastTotal !== 0) {
                let dTotal = currentTotal - lastTotal;
                let dIdle = currentIdle - lastIdle;

                if (dTotal > 0) {
                    root.cpu.usage = Math.max(0, Math.min(100, (1 - dIdle / dTotal)));
                }
            }

            lastTotal = currentTotal;
            lastIdle = currentIdle;
        }
    }

    Timer {
        id: cpuStatTimer
        running: true
        triggeredOnStart: true
        interval: 1000
        repeat: true

        onTriggered: {
            cpuStatFile.reload();
        }
    }

    Process {
        id: scanHwmon

        command: ["sh", "-c", "for d in /sys/class/hwmon/hwmon*/name; do echo \"$d:$(cat \"$d\" 2>/dev/null)\"; done"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                const cpuTargets = ["k10temp", "coretemp", "acpitz"];
                let foundCpuPath = "";
                let foundGpuPath = "";

                const sensors = {};
                for (const line of lines) {
                    if (!line.includes(":")) {
                        continue;
                    }
                    const [fullPath, name] = line.trim().split(":");
                    sensors[name] = fullPath.replace("/name", "");
                }

                for (const target of cpuTargets) {
                    if (sensors[target]) {
                        foundCpuPath = sensors[target];
                        break;
                    }
                }

                if (sensors["amdgpu"]) {
                    foundGpuPath = sensors["amdgpu"];
                }

                if (foundCpuPath) {
                    root._cpuHwmonPath = foundCpuPath;
                } else {
                    Logger.w("SYS_STATS", "No CPU hwmon sensor found");
                }

                if (foundGpuPath) {
                    root._gpuHwmonPath = foundGpuPath;
                } else {
                    Logger.w("SYS_STATS", "No GPU hwmon sensor found");
                }
            }
        }
    }

    FileView {
        id: cpuTempFile
        path: root._cpuHwmonPath ? root._cpuHwmonPath + "/temp1_input" : ""

        onLoaded: {
            const content = parseInt(text().trim() || "0", 10);
            if (!content) {
                return;
            }

            root.cpu.temp = content / 1000;
        }
    }

    Timer {
        id: cpuTempTimer
        interval: 3000
        running: true
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            cpuTempFile.reload();
        }
    }

    FileView {
        id: cpuInfoFile
        path: "/proc/cpuinfo"

        onLoaded: {
            const content = text();
            if (!content) {
                return;
            }
            const matches = content.match(/cpu MHz\s+:\s+([0-9.]+)/g);

            if (matches && matches.length > 0) {
                let sumFrequency = 0.0;
                for (let i = 0; i < matches.length; i++) {
                    sumFrequency += parseFloat(matches[i].split(":")[1]);
                }
                let avg = sumFrequency / matches.length;
                root.cpu.frequency = avg;
            }
        }
    }

    Timer {
        id: cpuInfoFileTimer
        interval: 3000
        running: true
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            cpuInfoFile.reload();
        }
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"

        onLoaded: {
            const content = text();
            if (!content) {
                return;
            }

            const memTotal = parseInt(content.match(/MemTotal:\s+(\d+)/)?.[1] || "0", 10);
            const memAvailable = parseInt(content.match(/MemAvailable:\s+(\d+)/)?.[1] || "0", 10);
            const swapTotal = parseInt(content.match(/SwapTotal:\s+(\d+)/)?.[1] || "0", 10);
            const swapFree = parseInt(content.match(/SwapFree:\s+(\d+)/)?.[1] || "0", 10);

            root.mem.ramTotal = memTotal * 1024;
            root.mem.ramUsed = (memTotal - memAvailable) * 1024;
            root.mem.ramUsedPercentage = memTotal > 0 ? (memTotal - memAvailable) / memTotal : 0;

            root.mem.swapTotal = swapTotal * 1024;
            root.mem.swapUsed = (swapTotal - swapFree) * 1024;
            root.mem.swapUsedPercentage = swapTotal > 0 ? (swapTotal - swapFree) / swapTotal : 0;
        }
    }

    Timer {
        id: memInfoTimer
        interval: 3000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            memFile.reload();
        }
    }

    Process {
        id: storageProc
        command: ["sh", "-c", "df --output=size,used,avail,pcent /"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length < 2) {
                    Logger.w("SYS_STATS", "df output empty");
                    return;
                }

                const dataLine = lines[1];
                const parts = dataLine.trim().split(/\s+/);

                if (parts.length < 3) {
                    Logger.w("SYS_STATS", "df parse failed: " + dataLine);
                    return;
                }

                const sizeKb = parseInt(parts[0], 10) || 0;
                const usedKb = parseInt(parts[1], 10) || 0;
                const availKb = parseInt(parts[2], 10) || 0;
                const percent = parseInt(parts[3], 10) || 0;

                root.storage.total = sizeKb * 1024;
                root.storage.used = usedKb * 1024;
                root.storage.usedPercentage = percent / 100;
            }
        }
    }

    Timer {
        id: storageProcTimer
        interval: 60000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            storageProc.running = true;
        }
    }

    FileView {
        id: gpuUsageFile
        path: root._gpuCardPath

        onLoaded: {
            const usage = parseInt(text().trim() || "0", 10);
            root.gpu.usage = Math.max(0, Math.min(1, usage / 100));
        }
    }

    Timer {
        id: gpuUsageTimer
        interval: 2000
        running: true
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            gpuUsageFile.reload();
        }
    }

    FileView {
        id: gpuTempFile
        path: root._gpuHwmonPath ? root._gpuHwmonPath + "/temp1_input" : ""

        onLoaded: {
            const raw = parseInt(text().trim() || "0", 10);
            if (raw > 0) {
                root.gpu.temp = raw / 1000;
            }
        }
    }

    Timer {
        id: gpuTempTimer
        interval: 5000
        running: true
        triggeredOnStart: true
        repeat: true
        onTriggered: {
            if (gpuTempFile.path) {
                gpuTempFile.reload();
            }
        }
    }

    Process {
        id: gpuCardScan
        command: ["sh", "-c", "for d in /sys/class/drm/card*/device/gpu_busy_percent; do if [ -f \"$d\" ]; then echo \"$d\"; break; fi; done"]
        stdout: StdioCollector {
            onStreamFinished: {
                const path = text.trim();
                if (path) {
                    root._gpuCardPath = path;
                } else {
                    Logger.w("SYS_STATS", "No GPU card with gpu_busy_percent found");
                }
            }
        }
    }

    Component.onCompleted: {
        scanHwmon.running = true;
        gpuCardScan.running = true;
    }
}
