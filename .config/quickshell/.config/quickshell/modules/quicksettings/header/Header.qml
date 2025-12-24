import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.services
import qs.modules.common

RowLayout {
    id: root
    Layout.fillHeight: false
    Layout.alignment: Qt.AlignTop

    Rectangle {
        implicitWidth: buttons.implicitWidth + Appearance.padding.normal * 2
        implicitHeight: buttons.implicitHeight + Appearance.padding.normal

        color: Colors.palette.m3surfaceContainer
        radius: Appearance.rounding.huge

        StyledText {
            id: uptime
            text: `${Time.uptime}`
            anchors.centerIn: parent
            size: 20
        }
    }

    Item {
        Layout.fillWidth: true
    }

    Rectangle {
        color: Colors.palette.m3surfaceContainer

        implicitWidth: buttons.implicitWidth + Appearance.padding.normal * 2
        implicitHeight: buttons.implicitHeight + Appearance.padding.normal

        radius: Appearance.rounding.huge

        RowLayout {
            id: buttons
            anchors.centerIn: parent

            spacing: Appearance.padding.small

            IconButton {
                icon: "restart_alt"
                padding: Appearance.padding.smaller
                // inactiveColor: Colors.palette.m3surface

                onClicked: {
                    GlobalStates.quicksettingsOpened = false;
                    Quickshell.execDetached(["bash", "-c", "killall qs; qs -d"]);
                }

                StyledTooltip {
                    text: "Restart Quickshell"
                    verticalPadding: Appearance.padding.normal
                    horizontalPadding: Appearance.padding.normal
                }
            }

            IconButton {
                icon: "settings"
                padding: Appearance.padding.smaller
                // inactiveColor: Colors.palette.m3surface

                onClicked: {
                    GlobalStates.quicksettingsOpened = false;
                }

                // TODO: make settings app
                StyledTooltip {
                    text: "Open settings [WIP]"
                    verticalPadding: Appearance.padding.normal
                    horizontalPadding: Appearance.padding.normal
                }
            }

            IconButton {
                icon: "power_settings_new"
                padding: Appearance.padding.smaller
                // inactiveColor: Colors.palette.m3surface
                // radius: Appearance.rounding.large

                onClicked: {
                    GlobalStates.quicksettingsOpened = false;
                    GlobalStates.powerMenuOpened = true;
                }

                StyledTooltip {
                    text: "Open power menu"
                    verticalPadding: Appearance.padding.normal
                    horizontalPadding: Appearance.padding.normal
                }
            }
        }
    }
}
