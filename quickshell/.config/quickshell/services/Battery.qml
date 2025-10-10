pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property int percentage: Math.round((UPower.displayDevice?.percentage ?? 0) * 100)
}
