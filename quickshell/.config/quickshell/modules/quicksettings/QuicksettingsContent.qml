import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common
import qs.modules.quicksettings.toggles
import qs.modules.quicksettings.header

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
        implicitHeight: 1000

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
                    }
                    StyledText {
                        text: `Uptime ${Time.uptime}`
                        size: 16
                        weight: 400
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
                implicitHeight: buttonsRow.implicitHeight+ 16
                radius: 24
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

            // TODO: notifications
            Item {
                Layout.fillHeight: true
            }
        }
    }
}
