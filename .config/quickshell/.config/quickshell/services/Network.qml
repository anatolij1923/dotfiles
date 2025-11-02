pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property bool wifi: true
    property bool ethernet: false

    property bool wifiEnabled: false
    property int wifiStrength

    property string icon: ethernet ? "lan" : wifiEnabled ? (wifiStrength > 80 ? "signal_wifi_4_bar" : wifiStrength > 60 ? "network_wifi_3_bar" : wifiStrength > 40 ? "network_wifi_2_bar" : wifiStrength > 20 ? "network_wifi_1_bar" : "signal_wifi_off") : "signal_wifi_off"
    function update() {
        // проверим тип соединения
        checkConnectionType.running = true;
        checkWifiStatus.running = true;
        checkStrength.running = true;
    }

    function enableWifi(enabled = true): void {
        const cmd = enabled ? "on" : "off";
        enableWifiProc.exec(["nmcli", "radio", "wifi", cmd]);
    }

    function toggleWifi(): void {
        enableWifi(!wifiEnabled);
    }

    Process {
        id: enableWifiProc
    }

    Process {
        id: checkConnectionType
        command: ["bash", "-c", "nmcli -t -f TYPE c show --active | head -1"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.ethernet = text.includes("ethernet");
            }
        }
    }

    Process {
        id: checkWifiStatus
        command: ["nmcli", "radio", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.wifiEnabled = text.trim() === "enabled";
            }
        }
    }

    Process {
        id: checkStrength
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL device wifi | awk '/^\\*/{print $2}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.wifiStrength = parseInt(text.trim()) || 0;
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.update()
    }

    Component.onCompleted: root.update()
}
