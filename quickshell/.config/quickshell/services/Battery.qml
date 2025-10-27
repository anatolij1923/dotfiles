pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
    property bool available: UPower.displayDevice.isLaptopBattery
    property var chargeState: UPower.displayDevice.state
    property bool isCharging: chargeState == UPowerDeviceState.Charging
    property int percentage: Math.round((UPower.displayDevice?.percentage ?? 0) * 100)

    property bool isLow: available && (percentage <= 35)
    property bool isCritical: available && (percentage <= isLow / 2)

    property bool isLowAndDischarging: isLow && !isCharging
    property bool isCriticalAndDischarging: isCritical && !isCharging

    onIsLowAndDischargingChanged: {
        if (available &&  isLowAndDischarging) {
            Quickshell.execDetached([
                "notify-send",
                "-u", "critical",
                "Low battery",
                "Plug in charger"
            ])
        }
    }
    onIsCriticalAndDischargingChanged: {
        if (available &&  isLowAndDischarging) {
            Quickshell.execDetached([
                "notify-send",
                "-u", "critical",
                "Critical low battery",
                "Plug in charger now"
            ])
        }
    }
}
