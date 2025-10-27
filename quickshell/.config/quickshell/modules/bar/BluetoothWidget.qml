import Quickshell
import QtQuick
import qs
import qs.modules.common
import Quickshell.Bluetooth

Item {
    id: root
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    MaterialSymbol {
        id: icon
        icon: Bluetooth.defaultAdapter?.enabled ? "bluetooth" : "bluetooth_disabled"
        color: Colors.on_surface
    }
}
