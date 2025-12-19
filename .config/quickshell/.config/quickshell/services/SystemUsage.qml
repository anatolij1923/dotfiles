pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Simple polled resource usage service with RAM, Swap, and CPU usage.
 */
Singleton {
    id: root
    property double memoryTotal: 1
    property double memoryFree: 1
    property double memoryUsed: memoryTotal - memoryFree
    property double memoryUsedPercentage: memoryUsed / memoryTotal
    property double swapTotal: 1
    property double swapFree: 1
    property double swapUsed: swapTotal - swapFree
    property double swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0
    property double cpuUsage: 0
    property var previousCpuStats
    property double cpuTemp: 0
    property real storageUsed
    property real storageTotal
    property real storagePerc: storageTotal > 0 ? storageUsed / storageTotal : 0

    Process {
        id: tempProcess
        command: ["sensors"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/Tctl:\s+\+([\d.]+)°C/);
                if (match)
                    cpuTemp = Number(match[1]);
            }
        }
    }

    Process {
        id: storage

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

                        // Only keep the entry with the largest total space for each device
                        if (!deviceMap.has(device) || (used + avail) > (deviceMap.get(device).used + deviceMap.get(device).avail)) {
                            deviceMap.set(device, {
                                used: used,
                                avail: avail
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

                root.storageUsed = totalUsed;
                root.storageTotal = totalUsed + totalAvail;
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            // Reload files
            fileMeminfo.reload();
            fileStat.reload();

            // Parse memory and swap usage
            const textMeminfo = fileMeminfo.text();
            memoryTotal = Number(textMeminfo.match(/MemTotal: *(\d+)/)?.[1] ?? 1);
            memoryFree = Number(textMeminfo.match(/MemAvailable: *(\d+)/)?.[1] ?? 0);
            swapTotal = Number(textMeminfo.match(/SwapTotal: *(\d+)/)?.[1] ?? 1);
            swapFree = Number(textMeminfo.match(/SwapFree: *(\d+)/)?.[1] ?? 0);

            // Parse CPU usage
            const textStat = fileStat.text();
            const cpuLine = textStat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (cpuLine) {
                const stats = cpuLine.slice(1).map(Number);
                const total = stats.reduce((a, b) => a + b, 0);
                const idle = stats[3];

                if (previousCpuStats) {
                    const totalDiff = total - previousCpuStats.total;
                    const idleDiff = idle - previousCpuStats.idle;
                    cpuUsage = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;
                }

                previousCpuStats = {
                    total,
                    idle
                };
            }

            // Parse CPU temp

            tempProcess.running = true;

            storage.running = true;
        }
    }

    FileView {
        id: fileMeminfo
        path: "/proc/meminfo"
    }
    FileView {
        id: fileStat
        path: "/proc/stat"
    }
}
