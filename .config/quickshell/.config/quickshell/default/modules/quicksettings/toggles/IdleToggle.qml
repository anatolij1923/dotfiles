import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.widgets

QuickToggle {
    icon: "coffee"
    checked: Idle.enabled
    onClicked: () => {
        Idle.toggle();
    }
    tooltipText: Translation.tr("quicksettings.toggles.idle")
}
