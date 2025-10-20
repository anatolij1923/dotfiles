import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

QuickToggle {
    icon: "coffee"
    checked: IdleInhibitor.enabled
    onClicked: () => {
        IdleInhibitor.toggle();
    }
    StyledTooltip {
        text: "Keep your system awake"
    }
}
