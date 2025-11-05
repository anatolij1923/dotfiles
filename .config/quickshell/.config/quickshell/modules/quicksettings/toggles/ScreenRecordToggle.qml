import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

// TODO: Add screen recording

QuickToggle {
    checked: false
    icon: "screen_record"

    onClicked: () => {
    // Notifications.dnd = !Notifications.dnd;
    }
    StyledTooltip {
        text: "Enable screen recording"
        verticalPadding: 8
        horizontalPadding: 12
    }
}
