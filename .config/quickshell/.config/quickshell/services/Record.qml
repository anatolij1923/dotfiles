pragma Singleton
import Quickshell
import QtQuick
import qs.utils

Singleton {
    id: root

    property bool isRecording: false
    property string duration: "00:00"
    property var startTime: 0

    Timer {
        interval: 1000
        running: root.isRecording
        repeat: true
        onTriggered: updateDuration()
    }

    function toggle() {
        Quickshell.execDetached([`${Paths.scriptsDir}/record.sh`]);

        if (root.isRecording) {
            stop();
        } else {
            start();
        }
    }

    function start() {
        root.isRecording = true;
    }
    function stop() {
        root.isRecording = false;
    }

    function updateDuration() {
        if (!root.isRecording)
            return;
        let diff = Date.now() - root.startTime;
        let seconds = Math.floor((diff / 1000) % 60);
        let minutes = Math.floor((diff / (1000 * 60)) % 60);
        let hours = Math.floor((diff / (1000 * 60 * 60)));

        let ss = seconds < 10 ? "0" + seconds : seconds;
        let mm = minutes < 10 ? "0" + minutes : minutes;

        if (hours > 0) {
            let hh = hours < 10 ? "0" + hours : hours;
            root.duration = `${hh}:${mm}:${ss}`;
        } else {
            root.duration = `${mm}:${ss}`;
        }
    }
}
