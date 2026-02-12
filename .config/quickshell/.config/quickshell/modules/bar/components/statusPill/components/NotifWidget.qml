import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets

Item {
    id: root
    property bool quicksettingsOpened
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    RowLayout {
        id: content
        spacing: 2

        StyledText {
            id: counter
            text: Notifications.list.length
            color: root.quicksettingsOpened ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
            Behavior on color {
                CAnim {}
            }
            visible: counter.text != "0"
            animate: true
        }
        MaterialSymbol {
            id: icon
            icon: Notifications.dnd ? "notifications_off" : "notifications_unread"
            color: root.quicksettingsOpened ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
            Behavior on color {
                CAnim {}
            }
            size: 22
        }
    }
}
