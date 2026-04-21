import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.widgets

QuickToggle {

    checked: Notifications.dnd
    icon: checked ? "notifications_off" : "notifications"

    onClicked: () => {
        Notifications.dnd = !Notifications.dnd;
    }

    tooltipText: Translation.tr("quicksettings.toggles.dnd")
}
