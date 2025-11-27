import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.config
import qs.services
import qs.modules.notifications
import qs.modules.common
import qs.modules.quicksettings.toggles
import qs.modules.quicksettings.header
import qs.modules.quicksettings.sliders

import Quickshell.Bluetooth

Item {
    id: root
    property int padding: 24

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 24
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
            spacing: 18
            Layout.fillHeight: true
            // Header
            RowLayout {
                id: header
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignTop

                ColumnLayout {
                    StyledText {
                        text: Quickshell.env("USER")
                        weight: 500
                    }
                    StyledText {
                        text: `Uptime ${Time.uptime}`
                        size: 16
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                IconButton {
                    implicitWidth: 52
                    implicitHeight: 52
                    icon: "power_settings_new"
                    radius: Appearance.rounding.large
                    inactiveColor: Colors.palette.m3surface

                    onClicked: {
                        GlobalStates.quicksettingsOpened = false;
                        GlobalStates.powerMenuOpened = true;
                    }

                    StyledTooltip {
                        text: "Open power menu"
                    }
                }
            }

            Toggles {}
            // RowLayout {
            //     Layout.fillWidth: true
            //     BigQuickToggle {
            //         title: "Network"
            //         substring: "Network name"
            //         checked: Network.wifiEnabled
            //         icon: Network.icon
            //         onClicked: () => {
            //             Network.toggleWifi();
            //         }
            //
            //         Layout.fillWidth: true
            //     }
            //     BigQuickToggle {
            //         title: "Bluetooth"
            //         // substring: "Network name"
            //         icon: BluetoothService.icon
            //         Layout.fillWidth: true
            //         checked: BluetoothService.enabled
            //         onClicked: () => {
            //             const adapter = Bluetooth.defaultAdapter;
            //             if (adapter)
            //                 adapter.enabled = !adapter.enabled;
            //         }
            //         onRightClicked: () => {
            //             Quickshell.execDetached(["blueman-manager"]);
            //             GlobalStates.quicksettingsOpened = false;
            //         }
            //     }
            // }
            //
            // RowLayout {
            //
            //     DNDToggle {}
            //     IdleToggle {}
            //     PowerprofilesToggle {}
            // }
            //
            // Rectangle {
            //     id: toggles
            //     color: Colors.palette.m3surfaceContainer
            //     // // Layout.fillWidth: true
            //     Layout.alignment: Qt.AlignHCenter
            //     // Layout.preferredHeight: 56
            //     implicitWidth: buttonsRow.implicitWidth + 16
            //     implicitHeight: buttonsRow.implicitHeight + 16
            //     radius: Appearance.rounding.huge
            //     // Toggles {}
            //     RowLayout {
            //         id: buttonsRow
            //         anchors.centerIn: parent
            //         spacing: 8
            //         NetworkToggle {}
            //         BluetoothToggle {}
            //         DNDToggle {}
            //         IdleToggle {}
            //         PowerprofilesToggle {}
            //     }
            // }

            Sliders {}

            Item {
                id: notificationList
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 12
                    RowLayout {
                        id: notificationListHeader
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: clearButton.implicitHeight
                            color: Qt.alpha(Colors.palette.m3surfaceContainer, 0.4)
                            radius: Appearance.rounding.normal

                            StyledText {
                                id: counter
                                anchors.centerIn: parent
                                text: `${Notifications.list.length} Notifications`
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        TextButton {
                            id: clearButton
                            text: "Clear"
                            onClicked: Notifications.clearAll()
                            padding: Appearance.padding.normal
                            inactiveColor: Qt.alpha(Colors.palette.m3surfaceContainer, 0.6)
                        }
                    }

                    NotificationListView {
                        id: persistentNotificationsView
                        model: Notifications.list
                        implicitWidth: parent.width
                        implicitHeight: notificationList.height
                    }
                }
            }
        }
    }
}
