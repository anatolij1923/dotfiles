import Quickshell
import QtQuick
import qs
import qs.services
import qs.config

QuickToggle {
    id: root

    icon: "opacity"

    checked: Config.appearance.transparency.enabled

    onClicked: {
        Config.appearance.transparency.enabled = !Config.appearance.transparency.enabled;
    }

    tooltipText: "Toggle transparency"
}
