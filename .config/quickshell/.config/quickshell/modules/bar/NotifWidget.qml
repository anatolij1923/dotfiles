import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

Item {
    id: root
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

    RowLayout {
        id: content
        spacing: 2

        StyledText {
            id: counter
            text: Notifications.list.length
            visible: counter.text != "0"
            animate: true
        }
        MaterialSymbol {
            id: icon
            icon: Notifications.dnd ? "notifications_off" : "notifications"
            color: Colors.palette.m3onSurface
        }
    }
}
