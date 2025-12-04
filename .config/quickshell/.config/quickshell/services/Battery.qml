pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property int percentage: Math.round((UPower.displayDevice?.percentage ?? 0) * 100)

    property bool isLow: available && (percentage <= 30)
    property bool isCritical: available && (percentage <= 15)

    property bool isLowAndDischarging: isLow && !isCharging
    property bool isCriticalAndDischarging: isCritical && !isCharging

    property real energyRate: UPower.displayDevice.changeRate
    property real timeToEmpty: UPower.displayDevice.timeToEmpty
    property real timeToFull: UPower.displayDevice.timeToFull

    onIsLowAndDischargingChanged: {
        if (available && isLowAndDischarging) {
            Quickshell.execDetached(["notify-send", "-u", "critical", "-a", "shell", "Low battery", "Plug in charger"]);
        }
    }
    onIsCriticalAndDischargingChanged: {
        if (available && isLowAndDischarging) {
            Quickshell.execDetached(["notify-send", "-u", "critical", "-a", "shell", "Critical low battery", "Plug in charger now"]);
        }
    }
}
