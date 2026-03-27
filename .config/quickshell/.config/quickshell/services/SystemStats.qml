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

        property var lastTotal: 0
        property var lastIdle: 0

        onLoaded: {
            let content = text();
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
        id: cpuTimer
        running: true
        interval: 1000
        repeat: true

        onTriggered: {
            cpuStatFile.reload();
        }
    }
}
