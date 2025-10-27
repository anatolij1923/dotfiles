import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.notifications
import qs.modules.common
import qs.modules.quicksettings.toggles
import qs.modules.quicksettings.header
import qs.modules.quicksettings.sliders

Item {
    id: root
    property int padding: 24

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 24
        color: Colors.surface
        implicitWidth: 550

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.padding
            spacing: 24
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
                    inactiveColor: Colors.surface

                    onClicked: {
                        GlobalStates.quicksettingsOpened = false;
                        GlobalStates.powerMenuOpened = true;
                    }

                    StyledTooltip {
                        text: "Open power menu"
                    }
                }
            }

            Rectangle {
                id: toggles
                color: Colors.surface_container
                // // Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                // Layout.preferredHeight: 56
                implicitWidth: buttonsRow.implicitWidth + 16
                implicitHeight: buttonsRow.implicitHeight + 16
                radius: Appearance.rounding.huge
                // Toggles {}
                RowLayout {
                    id: buttonsRow
                    anchors.centerIn: parent
                    spacing: 8
                    NetworkToggle {}
                    BluetoothToggle {}
                    DNDToggle {}
                    IdleToggle {}
                    PowerprofilesToggle {}
                }
            }

            Sliders {}

            // TODO: notifications
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
                            color: Qt.alpha(Colors.surface_container, 0.6)
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
                            inactiveColor: Qt.alpha(Colors.surface_container, 0.6)
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
