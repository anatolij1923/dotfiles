import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs
import qs.modules.common
import qs.services

Rectangle {
    id: root

    property int padding: Appearance.padding.normal

    implicitHeight: content.implicitHeight + padding * 2
    implicitWidth: content.implicitWidth + padding * 2

    color: Qt.alpha(Colors.surface_container, 0.4)
    radius: Appearance.rounding.huge
    Layout.fillWidth: true

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: Appearance.padding.normal
        anchors.margins: root.padding

        RowLayout {
            BigQuickToggle {
                title: "Network"
                substring: Network.networkName
                checked: Network.wifiEnabled
                icon: Network.icon
                onClicked: () => {
                    Network.toggleWifi();
                }

                Layout.fillWidth: true

                tooltipText: "Click to toggle Wi-Fi"
            }

            BigQuickToggle {
                title: "Bluetooth"
                // substring: "Network name"
                icon: BluetoothService.icon
                Layout.fillWidth: true
                checked: BluetoothService.enabled
                onClicked: () => {
                    const adapter = Bluetooth.defaultAdapter;
                    if (adapter)
                        adapter.enabled = !adapter.enabled;
                }
                onRightClicked: () => {
                    Quickshell.execDetached(["blueman-manager"]);
                    GlobalStates.quicksettingsOpened = false;
                }

                tooltipText: "Click to toggle Bluetooth. Right click to open Blueman"
            }
        }

        RowLayout {
            id: buttonsRow
            spacing: 4
            // NetworkToggle {}
            // BluetoothToggle {}
            DNDToggle {}
            IdleToggle {}
            PowerprofilesToggle {}
        }
    }
}
