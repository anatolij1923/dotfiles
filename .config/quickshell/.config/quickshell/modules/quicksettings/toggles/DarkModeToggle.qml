import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.widgets

QuickToggle {

    checked: Colors.isDarkMode
    icon: "contrast"

    onClicked: () => {
        Colors.switchDarkLightMode();
    }
    tooltipText: "Enable Dark Mode"
}
