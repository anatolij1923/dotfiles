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
                const targets = ["k10temp", "coretemp", "acpitz"];
                let foundPath = "";

                const sensors = {};
                for (const line of lines) {
                    if (!line.includes(":")) {
                        continue;
                    }
                    const [fullPath, name] = line.trim().split(":");
                    sensors[name] = fullPath.replace("/name", "");
                }

                for (const target of targets) {
                    if (sensors[target]) {
                        foundPath = sensors[target];
                        break;
                    }
                }

                if (foundPath) {
                    root._cpuHwmonPath = foundPath;
                } else {
                    Logger.w("SYS_STATS", "No hwmon sensor found");
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

    Component.onCompleted: {
        scanHwmon.running = true;
    }
}
