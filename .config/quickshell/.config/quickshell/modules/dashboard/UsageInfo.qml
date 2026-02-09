pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.config
import qs.widgets
import qs.common
import qs.services
import qs

Item {
    id: root

    width: parent.width
    height: content.implicitHeight

    ColumnLayout {
        id: content
        anchors.centerIn: parent
        width: parent.width
        spacing: Appearance.spacing.sm

        RamSwapSwitcher {
            Layout.fillWidth: true
        }

        UsageWidget {
            icon: "memory"
            label: Translation.tr("dashboard.usage.cpu")
            valueText: Math.round(SystemUsage.cpuUsage * 100) + "%"
            progressValue: SystemUsage.cpuUsage
            baseColor: Colors.palette.m3tertiary
        }

        UsageWidget {
            icon: "device_thermostat"
            label: Translation.tr("dashboard.usage.temperature")
            valueText: Math.round(SystemUsage.cpuTemp) + "°C"
            progressValue: Math.min(SystemUsage.cpuTemp / 100, 1)
            baseColor: Colors.palette.m3error
            isTemperature: true
        }
    }

    component RamSwapSwitcher: Item {
        id: switcher
        property bool showSwap: false

        implicitHeight: sliderRow.children[0].implicitHeight
        clip: true

        MouseArea {
            anchors.fill: parent
            onClicked: switcher.showSwap = !switcher.showSwap
        }

        Row {
            id: sliderRow
            x: switcher.showSwap ? -switcher.width : 0

            Behavior on x {
                Anim {
                    duration: Appearance.animDuration.expressiveFastSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                }
            }

            UsageWidget {
                width: switcher.width
                icon: "memory_alt"
                label: Translation.tr("dashboard.usage.memory")
                valueText: Math.round(SystemUsage.memoryUsedPercentage * 100) + "%"
                progressValue: SystemUsage.memoryUsedPercentage
                baseColor: Colors.palette.m3primary
            }

            UsageWidget {
                width: switcher.width
                icon: "swap_horiz"
                label: Translation.tr("dashboard.usage.swap")
                valueText: Math.round(SystemUsage.swapUsedPercentage * 100) + "%"
                progressValue: SystemUsage.swapUsedPercentage
                baseColor: Colors.palette.m3secondary
            }
        }
    }

    component UsageWidget: Item {
        id: widget
        property string icon
        property string label
        property string valueText
        property real progressValue
        property color baseColor
        property bool isTemperature: false

        readonly property bool isCritical: !isTemperature && progressValue > 0.85
        readonly property color dynamicColor: isCritical ? Colors.palette.m3error : baseColor

        Layout.fillWidth: true

        implicitHeight: col.implicitHeight + Appearance.spacing.md * 2

        ColumnLayout {
            id: col
            anchors.centerIn: parent
            width: parent.width
            spacing: Appearance.spacing.xs

            CircularProgress {
                id: circProgress
                Layout.alignment: Qt.AlignHCenter
                implicitSize: 85
                lineWidth: 8

                value: widget.progressValue

                colPrimary: widget.dynamicColor
                colSecondary: Qt.rgba(widget.dynamicColor.r, widget.dynamicColor.g, widget.dynamicColor.b, 0.2)

                Behavior on colPrimary {
                    CAnim {}
                }
                Behavior on colSecondary {
                    CAnim {}
                }

                MaterialSymbol {
                    anchors.centerIn: parent
                    icon: widget.icon
                    color: widget.dynamicColor
                    size: 30
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: -2

                StyledText {
                    text: widget.valueText
                    Layout.alignment: Qt.AlignHCenter
                    size: Appearance.font.size.large
                    weight: 700
                    font.family: "JetBrainsMono Nerd Font"
                    color: Colors.palette.m3onSurface
                }

                StyledText {
                    text: widget.label
                    Layout.alignment: Qt.AlignHCenter
                    size: Appearance.font.size.tiny
                    font.capitalization: Font.AllUppercase
                    font.letterSpacing: 2
                    weight: 500
                    color: Colors.palette.m3onSurfaceVariant
                    opacity: 0.8
                }
            }
        }
    }
}
