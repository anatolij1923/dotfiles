import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

QuickToggle {

    checked: Notifications.dnd
    icon: checked ? "notifications_off" : "notifications"

    onClicked: () => {
        Notifications.dnd = !Notifications.dnd;
    }
    StyledTooltip {
        text: "Do not disturb"
        verticalPadding: 8
        horizontalPadding: 12
    }
}
