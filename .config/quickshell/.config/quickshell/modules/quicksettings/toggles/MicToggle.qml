import Quickshell
import QtQuick
import qs
import qs.common
import qs.widgets
import qs.services

QuickToggle {
    checked: Audio.source.audio.muted
    icon: checked ? "mic_off" : "mic"

    onClicked: {
        Audio.source.audio.muted = !Audio.source.audio.muted;
    }

    tooltipText: "Mute microphone"
}
