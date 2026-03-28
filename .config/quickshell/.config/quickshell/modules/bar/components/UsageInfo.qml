pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs
import qs.services
import qs.common
import qs.widgets

BarWidget {
    id: root
    // padding: Appearance.spacing.lg

    rowContent: [
        RowLayout {
            spacing: Appearance.spacing.md
            UsageInfoWidget {
                value: SystemStats.cpu.usage
                icon: "memory"
            }

            UsageInfoWidget {
                value: SystemStats.mem.ramUsedPercentage
                icon: "memory_alt"
            }

            UsageInfoWidget {
                readonly property real minTemp: 22.0
                readonly property real maxTemp: 90.0
                property real rawTemp: SystemStats.cpu.temp
                value: Math.min(Math.max((rawTemp - minTemp) / (maxTemp - minTemp), 0.0), 1.0)
                icon: "local_fire_department"
            }
        }
    ]

    component UsageInfoWidget: RowLayout {
        id: usageWidgetRoot

        required property real value
        required property string icon

        spacing: 2

        MaterialSymbol {
            icon: usageWidgetRoot.icon
            color: Colors.palette.m3onSurface
            size: 24
        }

        VerticalProgressbar {
            value: usageWidgetRoot.value
            implicitHeight: parent.height * 0.7
            implicitWidth: 5
            fillColor: value >= 0.9 ? "#ff5050" : Colors.palette.m3secondary
        }
    }

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
    }

    UsageInfoPopup {
        hoverTarget: mouseArea
    }
}
