import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

// TODO: Add dark mode switching

QuickToggle {

    checked: Colors.isDarkMode
    icon: "contrast"

    onClicked: () => {
        Colors.isDarkMode = !Colors.isDarkMode
    }
    StyledTooltip {
        text: "Enable Dark Mode"
        verticalPadding: 8
        horizontalPadding: 12
    }
}
