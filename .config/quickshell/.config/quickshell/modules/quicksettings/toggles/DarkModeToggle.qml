import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

QuickToggle {

    checked: Colors.isDarkMode
    icon: "contrast"

    onClicked: () => {
        Colors.switchDarkLightMode();
    }
    StyledTooltip {
        text: "Enable Dark Mode"
        verticalPadding: 8
        horizontalPadding: 12
    }
}
