import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

Item {
    id: root
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    MaterialSymbol {
        id: icon
        icon: Notifications.dnd ? "notifications_off" : (Notifications.list.length > 0 ? "notifications_unread" : "notifications_none")
        color: Colors.on_surface
    }
}
