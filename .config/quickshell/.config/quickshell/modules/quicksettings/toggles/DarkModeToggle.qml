import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.widgets

QuickToggle {

    checked: Colors.isDarkMode
    icon: checked ? "dark_mode" : "light_mode"

    onClicked: () => {
        Colors.switchDarkLightMode();
    }
    tooltipText: checked ? "Enable light mode" : "Enable dark mode"
}
