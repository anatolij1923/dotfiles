import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

Item {
    id: root
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight

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
            ClippedFilledCircularProgress {
                implicitSize: 28
                MaterialSymbol {
                    anchors.centerIn: parent
                    color: Colors.on_surface
                    icon: "device_thermostat"
                    size: 22
                }
                value: Math.min(SystemUsage.cpuTemp / 100, 1)
            }
            StyledText {
                text: `${SystemUsage.cpuTemp.toFixed(0)}`
            }
        }

        RowLayout {
            id: mem
            ClippedFilledCircularProgress {
                implicitSize: 28
                MaterialSymbol {
                    anchors.centerIn: parent
                    color: Colors.on_surface
                    icon: "memory"
                    size: 24
                }
                value: SystemUsage.memoryUsedPercentage
            }
            StyledText {
                text: `${Math.round(SystemUsage.memoryUsedPercentage * 100).toString()}`
            }
        }
    }
}
