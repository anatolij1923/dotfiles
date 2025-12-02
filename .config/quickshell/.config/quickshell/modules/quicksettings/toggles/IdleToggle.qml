import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

QuickToggle {
    icon: "coffee"
    checked: Idle.enabled
    onClicked: () => {
        Idle.toggle();
    }
    tooltipText: "Keep your system awake"
}
