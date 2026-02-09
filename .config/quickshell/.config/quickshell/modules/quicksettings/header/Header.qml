import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.services
import qs.common
import qs.widgets

RowLayout {
    id: root
    Layout.fillHeight: false
    Layout.alignment: Qt.AlignTop

    Rectangle {
        implicitWidth: uptime.implicitWidth + Appearance.spacing.xl * 2
        implicitHeight: buttons.implicitHeight + Appearance.spacing.md

        color: Colors.palette.m3surfaceContainer
        radius: Appearance.rounding.full

        StyledText {
            id: uptime
            text: `${Time.uptime}`
            anchors.centerIn: parent
            size: Appearance.fontSize.md
            weight: 500
        }
    }

    Item {
        Layout.fillWidth: true
    }

    Rectangle {
        color: Colors.palette.m3surfaceContainer

        implicitWidth: buttons.implicitWidth + Appearance.spacing.sm * 2
        implicitHeight: buttons.implicitHeight + Appearance.spacing.md

        radius: Appearance.rounding.full

        RowLayout {
            id: buttons
            anchors.centerIn: parent

            spacing: Appearance.spacing.xs

            IconButton {
                icon: "restart_alt"
                padding: Appearance.spacing.sm
                // inactiveColor: Colors.palette.m3surface

                onClicked: {
                    GlobalStates.quicksettingsOpened = false;
                    Quickshell.execDetached(["bash", "-c", "killall qs; qs -d"]);
                }

                StyledTooltip {
                    text: Translation.tr("quicksettings.header.restart")
                }
            }

            IconButton {
                icon: "settings"
                padding: Appearance.spacing.sm
                // inactiveColor: Colors.palette.m3surface

                onClicked: {
                    GlobalStates.settingsOpened = true;
                    GlobalStates.quicksettingsOpened = false;
                }

                StyledTooltip {
                    text: Translation.tr("quicksettings.header.open_settings")
                }
            }

            IconButton {
                icon: "power_settings_new"
                padding: Appearance.spacing.sm
                // inactiveColor: Colors.palette.m3surface
                // radius: Appearance.rounding.xl

                onClicked: {
                    GlobalStates.quicksettingsOpened = false;
                    GlobalStates.powerMenuOpened = true;
                }

                StyledTooltip {
                    text: Translation.tr("quicksettings.header.open_power_menu")
                }
            }
        }
    }
}
