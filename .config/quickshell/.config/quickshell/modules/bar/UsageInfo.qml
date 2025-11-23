import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

BarWidget {
    id: root
    padding: Appearance.padding.huge

    RowLayout {
        id: content
        anchors.fill: parent
        spacing: 12

        // RowLayout {
        //     id: cpu
        //     MaterialSymbol {
        //         icon: "memory"
        //         color: Colors.on_surface
        //     }
        //     StyledText {
        //         text: `${Math.round(SystemUsage.cpuUsage * 100).toString()}`
        //     }
        // }

        RowLayout {
            id: temp
            CircularProgress {
                implicitSize: 30
                MaterialSymbol {
                    anchors.centerIn: parent
                    color: Colors.palette.m3onSurface
                    icon: "device_thermostat"
                    size: 20
                }
                value: Math.min(SystemUsage.cpuTemp / 100, 1)
            }
            StyledText {
                text: `${SystemUsage.cpuTemp.toFixed(0)}`
            }
        }

        RowLayout {
            id: mem
            CircularProgress {
                implicitSize: 30
                MaterialSymbol {
                    anchors.centerIn: parent
                    color: Colors.palette.m3onSurface
                    icon: "memory"
                    size: 20
                }
                value: SystemUsage.memoryUsedPercentage
            }
            StyledText {
                text: `${Math.round(SystemUsage.memoryUsedPercentage * 100).toString()}`
            }
        }
    }
}
