import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common
import Quickshell.Bluetooth

QuickToggle {
    checked: Bluetooth.defaultAdapter?.enabled ?? false

    icon: BluetoothService.icon
    onClicked: () => {
        const adapter = Bluetooth.defaultAdapter;
        if (adapter)
            adapter.enabled = !adapter.enabled;
    }
    onRightClicked: () => {
        Quickshell.execDetached(["blueman-manager"]);
        GlobalStates.quicksettingsOpened = false;
    }
    // onAlt: () => {
    //     Quickshell.execDetached(["blueman-manager"]);
    //     GlobalStates.quicksettingsOpened = false;
    // }
    StyledTooltip {
        text: BluetoothService.connected ? `${BluetoothService.battery}` : "Toggle bluetooth. Right click to open blueman"
    }
}
