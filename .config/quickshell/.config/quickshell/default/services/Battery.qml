pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick
import qs.config
import qs.common

Singleton {
    id: root

    readonly property var dev: UPower.displayDevice
    property bool available: dev?.isLaptopBattery ?? false

    property int percentage: Math.round((dev?.percentage ?? 0) * 100)
    property int state: dev?.state ?? UPowerDeviceState.Unknown
    property bool isCharging: state === UPowerDeviceState.Charging
    property bool isDischarging: state === UPowerDeviceState.Discharging
    property bool isFull: state === UPowerDeviceState.FullyCharged

    property real energyRate: UPower.displayDevice.changeRate
    property real timeToEmpty: UPower.displayDevice.timeToEmpty
    property real timeToFull: UPower.displayDevice.timeToFull

    property int _lastAlertLevel: 0

    readonly property bool isLow: percentage <= Config.battery.low
    readonly property bool isCritical: percentage <= Config.battery.critical

    readonly property int highThreshold: Config.battery.full ?? 80
    readonly property bool isHigh: percentage >= highThreshold

    function notify(title, message, urgency = "normal") {
        if (!Config.battery.sendNotifications)
            return;

        Quickshell.execDetached(["notify-send", "-u", urgency, "-a", "System", title, message]);
    }

    onPercentageChanged: checkBatteryStatus()
    onStateChanged: checkBatteryStatus()

    function checkBatteryStatus() {
        if (!available)
            return;

        if (isCharging || isFull) {
            if (isHigh && _lastAlertLevel < 1) {
                _lastAlertLevel = 1;
                Logger.i("BATT", `High level reached: ${percentage}%`);
                notify("Battery", `Fully charged`, "normal");
            }

            if (!isLow) {
                if (_lastAlertLevel < 0)
                    _lastAlertLevel = 0;
            }
            return;
        }

        if (isDischarging) {
            if (!isHigh && _lastAlertLevel > 0) {
                _lastAlertLevel = 0;
            }

            if (isCritical && _lastAlertLevel > -2) {
                _lastAlertLevel = -2;
                Logger.i("BATT", `Low level, ${_lastAlertLevel}`);
                notify("Critical low battery", `Plug in charger`, "critical");
                return;
            }

            if (isLow && !isCritical && _lastAlertLevel > -1) {
                _lastAlertLevel = -1;
                Logger.i("BATT", `Low level, ${_lastAlertLevel}`);
                notify("Low battery", `Plug in charger`, "critical");
                return;
            }
        }
    }
}
