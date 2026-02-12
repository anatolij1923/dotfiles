import QtQuick
import qs.common
import qs.widgets
import qs.services

Item {
    property bool quicksettingsOpened
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    MaterialSymbol {
        id: icon
        icon: "mic_off"
        color: root.quicksettingsOpened ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
        Behavior on color {
            CAnim {}
        }
        size: 22
    }
}
