import Quickshell
import QtQuick
import qs
import qs.services
import qs.common
import qs.widgets

QuickToggle {
    checked: Network.wifiEnabled
    icon: Network.icon
    onClicked: () => {
        Network.toggleWifi();
    }
    StyledTooltip {
        text: Translation.tr("quicksettings.toggles.wifi_tooltip")
    }
}
