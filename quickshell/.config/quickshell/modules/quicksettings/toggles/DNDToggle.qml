import Quickshell
import QtQuick
import qs
import qs.modules.common

QuickToggle {

    checked: false
    icon: "notifications"
    
    onClicked: () => {
        console.warn("gsd");
    }
    StyledTooltip {
        text: "Do not disturb"
    }
}
