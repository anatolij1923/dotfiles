import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

BarPopup {
    id: root

    padding: Appearance.spacing.xl

    ColumnLayout {
        StyledText {
            text: "Usage"
            size: 22
            weight: 600
            Layout.alignment: Qt.AlignHCenter
        }

        UsageWidget {
            icon: "memory_alt"
            value: SystemUsage.memoryUsedPercentage
            // desc: `Memory - ${Math.round(SystemUsage.memoryUsedPercentage * 100)}% ` + `${(SystemUsage.memoryUsed / 1024 / 1024).toFixed(1)} / ${(SystemUsage.memoryTotal / 1024 / 1024).toFixed(1)}`
            label: "Memory"
            metrics: `${Math.round(SystemUsage.memoryUsedPercentage * 100)}% ` + `${(SystemUsage.memoryUsed / 1024 / 1024).toFixed(1)} / ${(SystemUsage.memoryTotal / 1024 / 1024).toFixed(1)}`
        }

        UsageWidget {
            icon: "swap_horiz"
            value: SystemUsage.swapUsedPercentage
            label: "Swap"
            metrics: `${Math.round(SystemUsage.swapUsedPercentage * 99)}% ` + `${(SystemUsage.swapUsed / 1024 / 1024).toFixed(1)} / ${(SystemUsage.swapTotal / 1024 / 1024).toFixed(1)}`
        }

        UsageWidget {
            icon: "thermostat"
            value: Math.min(SystemUsage.cpuTemp / 100, 1)
            label: "Temperature"
            metrics: `${SystemUsage.cpuTemp.toFixed(0)} °C`
        }

        UsageWidget {
            icon: "memory"
            value: SystemUsage.cpuUsage
            label: "Usage"
            metrics: `${Math.round(SystemUsage.cpuUsage * 100)}%`
        }

        UsageWidget {
            icon: "hard_disk"
            value: SystemUsage.storagePerc
            label: "Disk"
            metrics: `${Math.round(SystemUsage.storagePerc * 100)}% ` + `${(SystemUsage.storageUsed / 1024 / 1024).toFixed(1)} / ` + `${(SystemUsage.storageTotal / 1024 / 1024).toFixed(1)} GB`
        }
    }

    component UsageWidget: RowLayout {
        id: usageWidget
        property string icon
        property alias value: circProgress.value
        property string label
        property string metrics
        spacing: Appearance.spacing.md

        CircularProgress {
            id: circProgress
            implicitSize: 64
            lineWidth: 6

            MaterialSymbol {
                icon: usageWidget.icon
                anchors.centerIn: parent
                color: Colors.palette.m3secondary
                size: 24
            }
        }

        RowLayout {
            id: textRow

            StyledText {
                id: label
                text: usageWidget.label
                weight: 500
            }

            StyledText {
                text: "-"
            }

            StyledText {
                id: metrics
                text: usageWidget.metrics
            }
        }
    }
}
