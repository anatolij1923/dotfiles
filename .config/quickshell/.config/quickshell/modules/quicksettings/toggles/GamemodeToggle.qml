import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.widgets

QuickToggle {

    checked: Gamemode.enabled
    icon: "stadia_controller"

    onClicked: () => {
        // Notifications.dnd = !Notifications.dnd;
        Gamemode.enable();
    }

    tooltipText: "Enable game mode"
}
