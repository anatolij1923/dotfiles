import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common
import Quickshell.Bluetooth

QuickToggle {
    checked: Bluetooth.defaultAdapter?.enabled ?? false


    icon: "bluetooth"
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
        text: "Toggle bluetooth. Right click to open blueman"
    }
}
