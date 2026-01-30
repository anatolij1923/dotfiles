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

    // CPU Temp
    Process {
        id: tempProcess
        command: ["sensors"]
        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/(?:Tctl|Package id 0):\s+\+([\d.]+)°C/);
                if (match)
                    root.cpuTemp = parseFloat(match[1]);
            }
        }
    }

    Timer {
        id: tempTimer
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: tempProcess.running = true
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
