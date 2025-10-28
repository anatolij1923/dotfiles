import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

QuickToggle {
    checked: Network.wifiEnabled
    icon: Network.icon
    onClicked: () => {
        Network.toggleWifi();
    }
    StyledTooltip {
        text: "Click to toggle Wi-Fi"
        verticalPadding: 8
        horizontalPadding: 12
    }
}
