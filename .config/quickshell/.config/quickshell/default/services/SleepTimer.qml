pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    property alias enabled: props.sleepTimerEnabled
    property var timers: [3600, 7200, 10800]
    property int modeIndex: 0
    property int remaining: 0

    signal timerStarted(int seconds)
    signal timerStopped
    signal timerFinished

    Timer {
        id: sleepTimer
        interval: 1000
        repeat: true
        running: false

        onTriggered: {
            if (root.remaining) {
                root.remaining -= 1;
            } else {
                root.stopTimer();
                Quickshell.execDetached(["bash", "-c", "playerctl -a pause"]);
                Quickshell.execDetached(["bash", "-c", "systemctl suspend -f"]);
                root.timerFinished();
            }
        }
    }

    function startTimer() {
        // stopTimer();
        sleepTimer.stop();
        root.remaining = root.timers[root.modeIndex];
        sleepTimer.start();
        props.sleepTimerEnabled = true;
        root.timerStarted(root.remaining);
    }

    function stopTimer() {
        sleepTimer.stop();
        root.remaining = 0;
        props.sleepTimerEnabled = false;
        root.modeIndex = 0;
        root.timerStopped();
    }

    function cycleTimer() {
        if (!root.enabled) {
            root.modeIndex = 0;
        } else {
            root.modeIndex = (root.modeIndex + 1) % root.timers.length;
        }
        startTimer();
    }

    PersistentProperties {
        id: props

        property bool sleepTimerEnabled

        reloadableId: "sleepTimer"
    }
}
