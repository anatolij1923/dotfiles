pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Service for polling system resource usage.
 */
Singleton {
    id: root

    // Memory
    property double memoryTotal: 1
    property double memoryUsed: 0
    property double memoryUsedPercentage: memoryTotal > 0 ? memoryUsed / memoryTotal : 0

    // Swap
    property double swapTotal: 1
    property double swapUsed: 0
    property double swapUsedPercentage: swapTotal > 0 ? swapUsed / swapTotal : 0

    // CPU Usage
    property double cpuUsage: 0

    // CPU Temperature
    property double cpuTemp: 0

    // Storage
    property real storageTotal: 0
    property real storageUsed: 0
    property real storagePerc: storageTotal > 0 ? storageUsed / storageTotal : 0

    // Memory and Swap
    FileView {
        id: meminfoFile
        path: "/proc/meminfo"
    }

    Timer {
        id: memoryTimer
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            meminfoFile.reload();
            const text = meminfoFile.text();

            const memTotal = parseInt(text.match(/MemTotal:\s+(\d+)/)?.[1] || 0);
            const memAvail = parseInt(text.match(/MemAvailable:\s+(\d+)/)?.[1] || 0);
            const swpTotal = parseInt(text.match(/SwapTotal:\s+(\d+)/)?.[1] || 0);
            const swpFree = parseInt(text.match(/SwapFree:\s+(\d+)/)?.[1] || 0);

            if (memTotal > 0) {
                root.memoryTotal = memTotal;
                root.memoryUsed = memTotal - memAvail;
            }

            if (swpTotal > 0) {
                root.swapTotal = swpTotal;
                root.swapUsed = swpTotal - swpFree;
            }
        }
    }

    // CPU Usage
    FileView {
        id: cpuStatFile
        path: "/proc/stat"
    }

    property var _prevCpu: ({
            total: 0,
            idle: 0
        })

    Timer {
        id: cpuUsageTimer
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuStatFile.reload();
            const text = cpuStatFile.text();
            if (!text)
                return;

            const line = text.split('\n')[0];
            const parts = line.trim().split(/\s+/).slice(1).map(Number);

            const total = parts.reduce((a, b) => a + b, 0);
            const idle = parts[3] + parts[4];

            const totalDiff = total - root._prevCpu.total;
            const idleDiff = idle - root._prevCpu.idle;

            if (root._prevCpu.total !== 0 && totalDiff > 0) {
                let usage = 1.0 - (idleDiff / totalDiff);
                root.cpuUsage = Math.max(0, Math.min(1, usage));
            }

            root._prevCpu = {
                total,
                idle
            };
        }
    }

    // CPU Temperature
    property string _hwmonPath: ""

    Process {
        id: hwmonScanProcess
        command: ["sh", "-c", "for d in /sys/class/hwmon/hwmon*/name; do echo \"$d:$(cat \"$d\" 2>/dev/null)\"; done"]
        stdout: StdioCollector {
            onStreamFinished: {
                let fallbackPath = "";
                for (const line of text.trim().split("\n")) {
                    const [path, name] = line.trim().split(":");
                    if (name === "k10temp") {
                        root._hwmonPath = path.replace("/name", "");
                        return;
                    }
                    if (name === "acpitz" && !fallbackPath)
                        fallbackPath = path.replace("/name", "");
                }
                if (!root._hwmonPath && fallbackPath)
                    root._hwmonPath = fallbackPath;
            }
        }
    }

    FileView {
        id: cpuTempFile
        path: root._hwmonPath ? root._hwmonPath + "/temp1_input" : ""
    }

    Component.onCompleted: hwmonScanProcess.running = true

    Timer {
        id: tempReadTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            if (cpuTempFile.path) {
                cpuTempFile.reload();
                const raw = parseInt(cpuTempFile.text().trim() || "0", 10);
                root.cpuTemp = raw / 1000;
            }
        }
    }

    // Storage
    Process {
        id: storageProcess
        command: ["sh", "-c", "df | grep '^/dev/' | awk '{print $1, $3, $4}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const deviceMap = new Map();
                for (const line of text.trim().split("\n")) {
                    if (line.trim() === "")
                        continue;
                    const parts = line.trim().split(/\s+/);
                    if (parts.length >= 3) {
                        const device = parts[0];
                        const used = parseInt(parts[1], 10) || 0;
                        const avail = parseInt(parts[2], 10) || 0;
                        if (!deviceMap.has(device) || (used + avail) > (deviceMap.get(device).used + deviceMap.get(device).avail)) {
                            deviceMap.set(device, {
                                used,
                                avail
                            });
                        }
                    }
                }
                let totalUsed = 0;
                let totalAvail = 0;
                for (const [device, stats] of deviceMap) {
                    totalUsed += stats.used;
                    totalAvail += stats.avail;
                }
                storageUsed = totalUsed;
                storageTotal = totalUsed + totalAvail;
            }
        }
    }

    Timer {
        id: storageTimer
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: storageProcess.running = true
    }
}
