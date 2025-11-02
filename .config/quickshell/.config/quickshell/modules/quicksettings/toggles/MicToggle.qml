
import Quickshell
import QtQuick
import qs
import qs.modules.common

StyledButton {
    implicitHeight: 40
    implicitWidth: toggled ? (pressed ? 64 : 56) : (pressed ? 56 : 40)
    buttonRadius: toggled ? (pressed ? 12 : 24) : (pressed ? 12 : 32)
    toggled: true
    buttonIcon: "mic"
    buttonIconSize: 28
    onClicked: () => {
        console.warn("gsd")
    }
}
