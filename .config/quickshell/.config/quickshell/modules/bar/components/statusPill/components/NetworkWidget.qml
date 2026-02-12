import Quickshell
import QtQuick
import qs
import qs.common
import qs.widgets
import qs.services

Item {
    id: root
    property bool quicksettingsOpened
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    MaterialSymbol {
        id: icon
        icon: Network.icon
        color: root.quicksettingsOpened ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
        Behavior on color {
            CAnim {}
        }
        size: 22
    }
}
