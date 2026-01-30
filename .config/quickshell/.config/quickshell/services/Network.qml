pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool wifi: true
    property bool ethernet: false
    property bool wifiEnabled: false
    property int wifiStrength: 0
    property string networkName: ""

    property string icon: ethernet ? "lan" : wifiEnabled ? (wifiStrength > 80 ? "signal_wifi_4_bar" : wifiStrength > 60 ? "network_wifi_3_bar" : wifiStrength > 40 ? "network_wifi_2_bar" : wifiStrength > 20 ? "network_wifi_1_bar" : "signal_wifi_off") : "signal_wifi_off"

    function enableWifi(enabled = true) {
        const cmd = enabled ? "on" : "off";
        enableWifiProc.exec(["nmcli", "radio", "wifi", cmd]);
    }

    function toggleWifi() {
        enableWifi(!wifiEnabled);
    }

    function getDisplayName() {
        return ethernet ? "Wired connection" : networkName || "Disconnected";
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
                root.wifi = text.includes("wifi");
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
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\\*/{print $2}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.wifiStrength = parseInt(text.trim()) || 0;
            }
        }
    }

    Process {
        id: checkNetworkName
        command: ["bash", "-c", "nmcli -t -f NAME c show --active | head -1"]
        stdout: StdioCollector {
            onStreamFinished: root.networkName = text.trim()
        }
    }

    function update() {
        checkConnectionType.running = true;
        checkWifiStatus.running = true;
        checkStrength.running = true;
        checkNetworkName.running = true;
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: root.update()
    }

    Component.onCompleted: root.update()
}
