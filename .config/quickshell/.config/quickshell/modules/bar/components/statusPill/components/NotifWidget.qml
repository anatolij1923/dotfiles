import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets

StatusPillWidget {
    property int counter: Notifications.list.length
    icon: Notifications.dnd ? "notifications_off" : "notifications_unread"
    text: counter > 0 ? counter : ""
}
