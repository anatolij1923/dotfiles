import Quickshell
import QtQuick
import qs
import qs.services
import qs.modules.common

Item {
    id: root
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    MaterialSymbol {
        id: icon
        icon: BluetoothService.icon
        color: Colors.on_surface
    }
}
