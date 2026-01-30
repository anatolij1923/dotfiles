import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.widgets

QuickToggle {
    id: root

    function formatTime(seconds) {
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        const s = seconds % 60;
        return h > 0 ? `${h}h ${m}m ${s}s` : `${m}m ${s}s`;
    }

    checked: SleepTimer.enabled

    icon: "timer"
    onClicked: () => {
        SleepTimer.cycleTimer();
    }
    onRightClicked: () => {
        SleepTimer.stopTimer();
    }

    tooltipText: {
        if (SleepTimer.enabled) {
            "Sleep timer. Right click to cancel\n" + `Remaining: ${root.formatTime(SleepTimer.remaining)}`;
        } else {
            "Sleep timer. Right click to cancel";
        }
    }
}
