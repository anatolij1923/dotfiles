import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root

    property int padding: Appearance.padding.normal
    signal openMicDialogRequested
    signal openNightLightDialogRequested

    implicitHeight: content.implicitHeight + padding * 2
    implicitWidth: content.implicitWidth + padding * 2

    color: Qt.alpha(Colors.palette.m3surfaceContainer, 0.4)
    radius: Appearance.rounding.huge
    Layout.fillWidth: true

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: Appearance.padding.normal
        anchors.margins: root.padding

        RowLayout {
            BigQuickToggle {
                title: Translation.tr("quicksettings.toggles.network")
                substring: Network.networkName
                checked: Network.wifiEnabled
                icon: Network.icon
                onClicked: () => {
                    Network.toggleWifi();
                }
                onRightClicked: () => {
                    Quickshell.execDetached("nmgui");
                    GlobalStates.quicksettingsOpened = false;
                }

                tooltipText: Translation.tr("quicksettings.toggles.network_tooltip")
                Layout.fillWidth: true
            }

            BigQuickToggle {
                Layout.fillWidth: true
                title: Translation.tr("quicksettings.toggles.bluetooth")
                substring: BluetoothService.firstActiveDevice.name
                icon: BluetoothService.icon
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

                tooltipText: BluetoothService.connected ? Translation.tr("quicksettings.toggles.bluetooth_tooltip_connected").replace("%1", BluetoothService.battery * 100) : Translation.tr("quicksettings.toggles.bluetooth_tooltip")
            }
        }

        RowLayout {
            id: buttonsRow
            spacing: Appearance.padding.smaller
            DNDToggle {}
            IdleToggle {}
            // GamemodeToggle {}
            SleepToggle {}
            MicToggle {
                onRightClicked: root.openMicDialogRequested()
                onHeld: root.openMicDialogRequested()
            }
        }

        RowLayout {
            spacing: Appearance.padding.smaller
            PowerprofilesToggle {}
            DarkModeToggle {}
            // TrasparencyToggle {}
            ScreenRecordToggle {}
            NightLightToggle {
                onRightClicked: root.openNightLightDialogRequested()
                onHeld: root.openNightLightDialogRequested()
            }
        }
    }
}
