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
}
