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
                value: SystemUsage.cpuUsage
                icon: "memory"
            }

            UsageInfoWidget {
                value: SystemUsage.memoryUsedPercentage
                icon: "memory_alt"
            }

            UsageInfoWidget {
                value: SystemUsage.storagePerc
                icon: "hard_disk"
            }

            UsageInfoWidget {
                value: SystemUsage.cpuTemp
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
