pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Bluetooth
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property bool enabled: Bluetooth.defaultAdapter?.enabled ?? false
    readonly property BluetoothDevice firstActiveDevice: Bluetooth.defaultAdapter?.devices.values.find(device => device.connected) ?? null
    readonly property bool connected: Bluetooth.devices.values.some(d => d.connected)

    property string icon: enabled ? (connected ? "bluetooth_connected" : "bluetooth") : "bluetooth_disabled"
}
