import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.config
import qs.widgets

QuickToggle {
    id: root

    icon: "opacity"

    checked: Config.appearance.transparency.enabled

    onClicked: {
        Config.appearance.transparency.enabled = !Config.appearance.transparency.enabled;
    }

    tooltipText: Translation.tr("quicksettings.toggles.transparency")
}
