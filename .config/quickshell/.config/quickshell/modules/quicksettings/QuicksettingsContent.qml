import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.config
import qs.services
import qs.modules.notifications
import qs.common
import qs.widgets
import qs.modules.quicksettings.toggles
import qs.modules.quicksettings.header
import qs.modules.quicksettings.sliders
import qs.modules.quicksettings.notificationsList
import qs.modules.quicksettings.media

import Quickshell.Bluetooth

Item {
    id: root
    property int padding: 16

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    // StyledShadow {
    //     target: root
    //     radius: background.radius
    // }

    ClippingRectangle {
        id: background
        anchors.fill: parent
        radius: Appearance.rounding.xl
        color: root.transparent ? Qt.alpha(Colors.palette.m3surface, root.alpha) : Colors.palette.m3surface
        clip: true
        Behavior on color {
            CAnim {}
        }
        // implicitWidth: 500

        border.width: 1
        border.color: Colors.palette.m3surfaceContainerHigh

        Behavior on border.color {
            CAnim {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.padding
            spacing: Appearance.spacing.md
            Layout.fillHeight: true
            Header {}
            Toggles {
                id: toggles
                onOpenMicDialogRequested: () => micDialog.open()
                onOpenNightLightDialogRequested: () => nightLightDialog.open()
                onOpenBluetoothDialogRequested: () => bluetoothDialog.open()
            }
            Sliders {}
            // MediaPlayer {}
            NotificationsList {}
        }

        M3Dialog {
            id: micDialog
            anchors.fill: parent
            visible: false
            title: Translation.tr("quicksettings.dialogs.mic.title")

            DialogDivider {}
            DialogSwitchRow {
                label: Translation.tr("quicksettings.dialogs.mic.mute")
                value: Audio.source.audio.muted
                onToggled: v => Audio.source.audio.muted = v
            }
            // DialogSliderRow {
            //     value: 0.7
            //     stopIndicatorValues: [0, 0.25, 0.5, 0.75, 1]
            //     onValueChanged: () => { /* placeholder */ }
            // }

            DialogSliderRow {
                label: Translation.tr("quicksettings.dialogs.mic.input_volume")
                value: Audio.source.audio.volume
                onMoved: v => Audio.source.audio.volume = v
            }
        }
        M3Dialog {
            id: nightLightDialog
            anchors.fill: parent
            visible: false
            title: Translation.tr("quicksettings.dialogs.night_light.title")

            onVisibleChanged: if (visible)
                NightLightService.refreshConfig()

            DialogDivider {}
            DialogSwitchRow {
                label: Translation.tr("quicksettings.dialogs.night_light.enable")
                value: NightLightService.running
                onToggled: v => v ? NightLightService.start() : NightLightService.stop()
            }
            DialogSliderRow {
                id: nightTempRow
                label: Translation.tr("quicksettings.dialogs.night_light.temperature")
                value: NightLightService.temperature
                from: 1000
                to: 6500
                stopIndicatorValues: [1000, 2000, 3000, 4000, 5000, 6000]
                valueSuffix: " K"
                tooltipContent: Math.round(NightLightService.temperature) + " K"
                // onValueChanged: () => NightLightService.setTemperature(nightTempRow.value)
                onMoved: v => NightLightService.setTemperature(v)
            }
            DialogSliderRow {
                id: nightGammaRow
                label: Translation.tr("quicksettings.dialogs.night_light.night_gamma")
                value: NightLightService.gamma
                from: 10
                to: 100
                stopIndicatorValues: [25, 50, 75, 100]
                valueSuffix: " %"
                tooltipContent: (NightLightService.gamma).toFixed(1) + " %"
                // onValueChanged: () => NightLightService.setGamma(nightGammaRow.value)
                onMoved: v => NightLightService.setGamma(v)
            }
        }
        M3Dialog {
            id: bluetoothDialog
            anchors.fill: parent
            visible: false
            title: Translation.tr("quicksettings.dialogs.bluetooth.title")

            DialogDivider {}
            DialogSwitchRow {
                label: Translation.tr("quicksettings.dialogs.bluetooth.enable")
                value: BluetoothService.enabled
                onToggled: v => BluetoothService.setEnabled(v)
            }
            // DialogDivider {}
            StyledText {
                text: Translation.tr("quicksettings.dialogs.bluetooth.devices")
                size: Appearance.fontSize.sm
                Layout.bottomMargin: Appearance.spacing.sm
                Layout.topMargin: Appearance.spacing.sm
            }
            ListView {
                id: btDeviceList
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(220, (Bluetooth.defaultAdapter?.devices?.values?.length ?? 0) * 40)
                clip: true
                model: Bluetooth.defaultAdapter?.devices?.values ?? []
                spacing: 2
                delegate: Rectangle {
                    width: btDeviceList.width - 2
                    height: 36
                    radius: Appearance.rounding.md
                    color: Colors.palette.m3surfaceContainerHigh
                    required property var modelData
                    property var device: modelData
                    StateLayer {
                        id: deviceRow
                        anchors.fill: parent
                        onClicked: {
                            if (device && !device.pairing)
                                BluetoothService.toggleDevice(device);
                        }
                    }
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Appearance.spacing.md
                        anchors.rightMargin: Appearance.spacing.md
                        spacing: Appearance.spacing.sm
                        MaterialSymbol {
                            icon: device?.connected ? "bluetooth_connected" : "bluetooth"
                            color: device?.connected ? Colors.palette.m3primary : Colors.palette.m3onSurfaceVariant
                            size: 20
                        }
                        StyledText {
                            text: device?.name || device?.deviceName || device?.address || ""
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                        }
                        StyledText {
                            visible: device?.connected && device?.batteryAvailable
                            text: Math.round((device?.battery ?? 0) * 100) + "%"
                            size: Appearance.fontSize.sm
                            color: Colors.palette.m3onSurfaceVariant
                        }
                    }
                }
            }
            TextIconButton {
                Layout.topMargin: Appearance.spacing.sm

                text: BluetoothService.discovering ? Translation.tr("quicksettings.dialogs.bluetooth.scanning") : Translation.tr("quicksettings.dialogs.bluetooth.scan")
                icon: BluetoothService.discovering ? "search" : "add"
                onClicked: BluetoothService.discovering ? BluetoothService.stopDiscovery() : BluetoothService.startDiscovery()
                opacity: (BluetoothService.enabled && !BluetoothService.discovering) ? 1 : 0.75
            }
        }
    }
}
