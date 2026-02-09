import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

BarPopup {
    id: root

    function formatTime(seconds) {
        if (!seconds || seconds <= 0)
            return "--m";
        if (seconds > 86400)
            return "Calculating...";

        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);

        if (h > 0)
            return `${h}h ${m}m`;
        return `${m}m`;
    }

    padding: Appearance.spacing.xl

    ColumnLayout {
        spacing: 12

        RowLayout {
            spacing: 8

            StyledText {
                text: `${Battery.percentage}%`
                size: Appearance.fontSize.xxl
                weight: 600
                color: Colors.palette.m3onSurface
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: Battery.isCharging ? "Charging" : "Discharging"
                size: Appearance.fontSize.lg
                weight: 500

                color: Colors.palette.m3onSurface
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Rectangle {
                id: progressBarBg
                Layout.fillWidth: true
                implicitHeight: 8
                radius: 4
                color: Colors.palette.m3surfaceVariant

                Rectangle {
                    id: progressBarFill
                    implicitHeight: parent.height
                    width: (Battery.percentage / 100) * parent.width
                    radius: 4
                    color: Battery.isCharging ? Colors.palette.m3primary : Colors.palette.m3secondary

                    Behavior on color {
                        CAnim {}
                    }

                    Behavior on width {
                        Anim {}
                    }
                }
            }
        }

        RowLayout {
            spacing: 8

            Rectangle {
                implicitWidth: 36
                implicitHeight: 36
                radius: Appearance.rounding.full
                color: Colors.palette.m3secondaryContainer

                MaterialSymbol {
                    icon: Battery.isCharging ? "bolt" : "schedule"
                    anchors.centerIn: parent
                    color: Colors.palette.m3onSecondaryContainer
                    size: 20
                }
            }

            StyledText {
                text: {
                    if (Battery.isCharging) {
                        if (Battery.percentage >= 99)
                            return "Fully Charged";
                        return root.formatTime(Battery.timeToFull) + " to full";
                    } else {
                        return root.formatTime(Battery.timeToEmpty) + " remaining";
                    }
                }
                size: Appearance.fontSize.md
                color: Colors.palette.m3onSurface
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                visible: Battery.energyRate > 0

                MaterialSymbol {
                    icon: "power"
                    color: Colors.palette.m3secondary
                    size: 20
                }

                StyledText {
                    text: Battery.energyRate.toFixed(1) + " W"
                    size: Appearance.fontSize.md
                    color: Colors.palette.m3onSurfaceVariant
                }
            }
        }
    }
}
