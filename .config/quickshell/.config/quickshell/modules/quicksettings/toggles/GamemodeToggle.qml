import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

QuickToggle {

    checked: Gamemode.enabled
    icon: "stadia_controller"

    onClicked: () => {
        // Notifications.dnd = !Notifications.dnd;
        Gamemode.enable()
    }
    StyledTooltip {
        text: "Enable game mode"
        verticalPadding: 8
        horizontalPadding: 12
    }
}
