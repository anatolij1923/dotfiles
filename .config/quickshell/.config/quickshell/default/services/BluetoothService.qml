pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Bluetooth
import QtQuick

/**
 * Exposes adapter state, connected devices, battery, and control methods.
 * @see https://quickshell.org/docs/v0.2.1/types/Quickshell.Bluetooth/
 */
Singleton {
    id: root

    // --- Adapter (defaultAdapter can be null if no BT hardware / BlueZ down) ---
    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property bool enabled: adapter?.enabled ?? false
    readonly property bool discovering: adapter?.discovering ?? false
    readonly property string adapterName: adapter?.name ?? ""

    // --- Connected devices (filter by device.connected — Bluetooth.devices can be stale) ---
    readonly property var _allDevices: adapter?.devices?.values ?? []
    readonly property var _connectedList: _allDevices.filter(d => d.connected)
    readonly property bool connected: _connectedList.length > 0
    /** First connected device (for name, battery, disconnect). Null if none. */
    readonly property BluetoothDevice firstActiveDevice: _connectedList.length > 0 ? _connectedList[0] : null
    /** Safe display name for UI when firstActiveDevice may be null. */
    readonly property string connectedDeviceName: firstActiveDevice?.name ?? ""

    // --- Battery (0.0..1.0), only valid when device reports it ---
    readonly property real battery: (firstActiveDevice?.batteryAvailable && firstActiveDevice) ? firstActiveDevice.battery : 0

    // Icon for bar / toggles
    readonly property string icon: enabled ? (connected ? "bluetooth_connected" : "bluetooth") : "bluetooth_disabled"

    // Adapter control
    function setEnabled(on) {
        if (adapter)
            adapter.enabled = !!on;
    }
    function toggle() {
        setEnabled(!enabled);
    }
    function startDiscovery() {
        if (adapter)
            adapter.discovering = true;
    }
    function stopDiscovery() {
        if (adapter)
            adapter.discovering = false;
    }
    function toggleDiscovery() {
        if (adapter)
            adapter.discovering = !adapter.discovering;
    }

    function connectDevice(device) {
        if (device)
            device.connect();
    }
    function disconnectDevice(device) {
        if (device)
            device.disconnect();
    }
    function forgetDevice(device) {
        if (device)
            device.forget();
    }
    function toggleDevice(device) {
        if (device)
            device.connected = !device.connected;
    }
}
