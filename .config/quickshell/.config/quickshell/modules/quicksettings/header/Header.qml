import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets

RowLayout {
    id: root
    Layout.fillHeight: false

    Rectangle {
        implicitWidth: uptime.implicitWidth + Appearance.spacing.xxl * 2
        implicitHeight: buttons.implicitHeight + Appearance.spacing.sm

        color: Colors.alpha(Colors.palette.m3surfaceContainer, 0.4)
        radius: Appearance.rounding.full

        StyledText {
            id: uptime
            text: Time.uptime
            anchors.centerIn: parent
            color: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.15)
        }
    }

    Item {
        Layout.fillWidth: true
    }

    Rectangle {

        implicitWidth: buttons.implicitWidth + Appearance.spacing.xs * 2
        implicitHeight: buttons.implicitHeight + Appearance.spacing.sm

        color: Colors.alpha(Colors.palette.m3surfaceContainer, 0.4)
        radius: Appearance.rounding.full

        RowLayout {
            id: buttons
            anchors.centerIn: parent

            spacing: Appearance.spacing.xs

            IconButton {
                icon: "restart_alt"
                padding: Appearance.spacing.sm
                inactiveColor: "transparent"

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
                inactiveColor: "transparent"

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
                inactiveColor: "transparent"

                onClicked: {
                    GlobalStates.quicksettingsOpened = false;
                    GlobalStates.sessionOpened = true;
                }

                StyledTooltip {
                    text: Translation.tr("quicksettings.header.open_power_menu")
                }
            }
        }
    }
}
