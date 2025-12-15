import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common

BarPopup {
    id: root

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
            desc: `Memory - ${Math.round(SystemUsage.memoryUsedPercentage * 100)}% ` + `${(SystemUsage.memoryTotal / 1024 / 1024).toFixed(1)}/${(SystemUsage.memoryUsed / 1024 / 1024).toFixed(1)}`
        }

        UsageWidget {
            icon: "swap_horiz"
            value: SystemUsage.swapUsedPercentage
            desc: `Swap - ${Math.round(SystemUsage.swapUsedPercentage * 100)}% ` + `${(SystemUsage.swapTotal / 1024 / 1024).toFixed(1)}/${(SystemUsage.swapUsed / 1024 / 1024).toFixed(1)}`
        }

        UsageWidget {
            icon: "thermostat"
            value: Math.min(SystemUsage.cpuTemp / 100, 1)
            desc: `CPU Temp - ${SystemUsage.cpuTemp.toFixed(0)} °C`
        }

        UsageWidget {
            icon: "memory"
            value: SystemUsage.cpuUsage
            desc: `CPU Usage - ${Math.round(SystemUsage.cpuUsage * 100)}%`
        }
    }

    component UsageWidget: RowLayout {
        id: usageWidget
        property string icon
        property alias value: circProgress.value
        property string desc
        spacing: Appearance.padding.normal

        CircularProgress {
            id: circProgress
            implicitSize: 50
            lineWidth: 4

            MaterialSymbol {
                icon: usageWidget.icon
                anchors.centerIn: parent
                color: Colors.palette.m3secondary
                size: 20
            }
        }

        StyledText {
            text: usageWidget.desc
        }
    }
}
