import QtQuick
import qs.widgets
import qs.services
import qs.common

Item {
    id: root
    property bool quicksettingsOpened
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    MaterialSymbol {
        id: icon
        icon: "coffee"
            color: root.quicksettingsOpened ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
            Behavior on color {
                CAnim {}
            }
        size: 22
    }
}
