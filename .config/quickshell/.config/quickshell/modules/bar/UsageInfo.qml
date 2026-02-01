import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets

BarWidget {
    id: root
    // padding: Appearance.padding.large

    rowContent: [
        RowLayout {
            id: content
            spacing: 12

            RowLayout {
                id: mem
                CircularProgress {
                    implicitSize: 32
                    MaterialSymbol {
                        anchors.centerIn: parent
                        color: Colors.palette.m3onSurface
                        icon: "memory_alt"
                        size: 22
                    }
                    value: SystemUsage.memoryUsedPercentage
                }
                StyledText {
                    text: `${Math.round(SystemUsage.memoryUsedPercentage * 100).toString()}`
                }
            }
        }
    ]

    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: parent
    }

    UsageInfoPopup {
        hoverTarget: mouseArea
    }
}
