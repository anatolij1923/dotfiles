import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

// TODO: Add dark mode switching

QuickToggle {

    checked: true
    icon: "contrast"

    onClicked: () => {
        // Notifications.dnd = !Notifications.dnd;
    }
    StyledTooltip {
        text: "Enable Dark Mode"
        verticalPadding: 8
        horizontalPadding: 12
    }
}
