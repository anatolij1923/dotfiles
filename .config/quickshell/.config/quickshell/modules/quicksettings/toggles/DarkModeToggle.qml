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
    tooltipText: checked ? Translation.tr("quicksettings.toggles.light_mode") : Translation.tr("quicksettings.toggles.dark_mode")
}
