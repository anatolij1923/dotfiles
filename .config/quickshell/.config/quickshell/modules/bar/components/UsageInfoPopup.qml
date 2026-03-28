import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

BarPopup {
    id: root

    padding: Appearance.spacing.lg

    ColumnLayout {
        spacing: Appearance.spacing.sm

        // Header
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Appearance.spacing.sm

            Rectangle {
                implicitWidth: 36
                implicitHeight: 36
                radius: Appearance.rounding.md
                color: Colors.palette.m3primaryContainer

                MaterialSymbol {
                    icon: "dashboard"
                    anchors.centerIn: parent
                    color: Colors.palette.m3onPrimaryContainer
                    size: 22
                }
            }

            StyledText {
                text: "System Monitor"
                size: Appearance.fontSize.md
                weight: 700
                color: Colors.palette.m3onSurface
            }
        }

        // CPU
        MetricBar {
            Layout.fillWidth: true
            icon: "memory"
            label: "CPU"
            value: SystemStats.cpu.usage
            valueText: `${Math.round(SystemStats.cpu.usage * 100)}%`
            subLabel: SystemStats.cpu.temp > 0 ? `${SystemStats.cpu.temp.toFixed(1)}°C` : "N/A"
            subLabel2: SystemStats.cpu.frequency > 0 ? `${(SystemStats.cpu.frequency / 1000).toFixed(2)} GHz` : "N/A"
        }

        // GPU
        MetricBar {
            Layout.fillWidth: true
            icon: "gamepad"
            label: "GPU"
            value: SystemStats.gpu.usage
            valueText: SystemStats.gpu.usage > 0 ? `${Math.round(SystemStats.gpu.usage * 100)}%` : "N/A"
            subLabel: SystemStats.gpu.temp > 0 ? `${SystemStats.gpu.temp.toFixed(1)}°C` : "N/A"
        }

        // RAM
        MetricBar {
            Layout.fillWidth: true
            icon: "memory_alt"
            label: "RAM"
            value: SystemStats.mem.ramUsedPercentage
            valueText: `${Math.round(SystemStats.mem.ramUsedPercentage * 100)}%`
            subLabel: `${(SystemStats.mem.ramUsed / 1024 / 1024 / 1024).toFixed(1)} GB`
            subLabel2: `${(SystemStats.mem.ramTotal / 1024 / 1024 / 1024).toFixed(1)} GB`
        }

        // Swap
        MetricBar {
            Layout.fillWidth: true
            icon: "swap_horiz"
            label: "Swap"
            value: SystemStats.mem.swapUsedPercentage
            valueText: `${Math.round(SystemStats.mem.swapUsedPercentage * 100)}%`
            subLabel: `${(SystemStats.mem.swapUsed / 1024 / 1024 / 1024).toFixed(1)} GB`
            subLabel2: `${(SystemStats.mem.swapTotal / 1024 / 1024 / 1024).toFixed(1)} GB`
        }

        // Storage
        MetricBar {
            Layout.fillWidth: true
            icon: "hard_disk"
            label: "Storage"
            value: SystemStats.storage.usedPercentage
            valueText: `${Math.round(SystemStats.storage.usedPercentage * 100)}%`
            subLabel: `${(SystemStats.storage.used / 1024 / 1024 / 1024).toFixed(0)} GB`
            subLabel2: `${(SystemStats.storage.total / 1024 / 1024 / 1024).toFixed(0)} GB`
        }

        // Network
        RowLayout {
            Layout.fillWidth: true
            spacing: Appearance.spacing.md

            NetworkPill {
                Layout.fillWidth: true
                label: "Download"
                value: SystemStats.network.downloadSpeed
                icon: "arrow_downward"
                accentColor: Colors.palette.m3secondary
            }

            NetworkPill {
                Layout.fillWidth: true
                label: "Upload"
                value: SystemStats.network.uploadSpeed
                icon: "arrow_upward"
                accentColor: Colors.palette.m3tertiary
            }
        }
    }

    // Metric Bar Component
    component MetricBar: Rectangle {
        id: metricBar
        property string icon
        property string label
        property real value
        property string valueText
        property string subLabel
        property string subLabel2
        property real warningThreshold: 0.7
        property real dangerThreshold: 0.85

        implicitHeight: metricBarLayout.implicitHeight + Appearance.spacing.md * 2
        radius: Appearance.rounding.md
        color: Colors.palette.m3surfaceContainerHigh

        property color _accentColor: {
            if (value >= dangerThreshold)
                return Colors.palette.m3error;
            if (value >= warningThreshold)
                return "#ffb74d";
            return Colors.palette.m3secondary;
        }

        RowLayout {
            id: metricBarLayout
            anchors.fill: parent
            anchors.margins: Appearance.spacing.md
            spacing: Appearance.spacing.md

            // Icon
            MaterialSymbol {
                icon: metricBar.icon
                color: metricBar._accentColor
                size: 32
            }

            // Info
            ColumnLayout {
                Layout.fillWidth: true

                // Label + Value row
                RowLayout {
                    Layout.fillWidth: true

                    StyledText {
                        text: metricBar.label
                        size: Appearance.fontSize.md
                        weight: 500
                        color: Colors.palette.m3onSurfaceVariant
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    StyledText {
                        text: metricBar.valueText
                        size: Appearance.fontSize.md
                        weight: 650
                        color: metricBar._accentColor
                    }
                }

                // Progress bar
                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 6
                    radius: Appearance.rounding.full
                    color: Colors.palette.m3surfaceContainerHighest

                    Rectangle {
                        height: parent.height
                        width: Math.min(metricBar.value, 1) * parent.width
                        radius: parent.radius
                        color: metricBar._accentColor
                    }
                }

                // SubLabels
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Appearance.spacing.sm

                    StyledText {
                        text: metricBar.subLabel
                        size: Appearance.fontSize.sm
                        color: Colors.palette.m3onSurfaceVariant
                    }

                    StyledText {
                        text: metricBar.subLabel2 === "" ? "" : "|"
                        size: Appearance.fontSize.sm
                        color: Colors.palette.m3onSurfaceVariant
                        opacity: 0.5
                    }

                    StyledText {
                        text: metricBar.subLabel2
                        size: Appearance.fontSize.sm
                        color: Colors.palette.m3onSurfaceVariant
                    }
                }
            }
        }
    }

    // Network Pill Component
    component NetworkPill: Rectangle {
        id: networkPill
        property string label
        property real value
        property string icon
        property color accentColor

        implicitHeight: networkPillLayout.implicitHeight + Appearance.spacing.sm * 2
        implicitWidth: networkPillLayout.implicitWidth + Appearance.spacing.sm * 2
        radius: Appearance.rounding.md
        color: Colors.palette.m3surfaceContainerHigh

        RowLayout {
            id: networkPillLayout
            anchors.fill: parent
            anchors.margins: Appearance.spacing.sm
            spacing: Appearance.spacing.sm

            MaterialSymbol {
                icon: networkPill.icon
                color: networkPill.accentColor
                size: 20
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                StyledText {
                    text: networkPill.label
                    size: Appearance.fontSize.xs
                    weight: 500
                    color: Colors.palette.m3onSurfaceVariant
                }

                StyledText {
                    text: `${value.toFixed(0)} KB/s`
                    size: Appearance.fontSize.sm
                    weight: 700
                    color: networkPill.accentColor
                }
            }
        }
    }
}
