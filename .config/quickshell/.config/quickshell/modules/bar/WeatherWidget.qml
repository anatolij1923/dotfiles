import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

BarWidget {
    id: root

    padding: Appearance.padding.large

    rowContent: [
        RowLayout {
            id: content
            // anchors.centerIn: parent

            MaterialSymbol {
                icon: Weather.data.icon
                color: Colors.palette.m3onSurface
            }

            RowLayout {
                spacing: 2
                StyledText {
                    text: `${Weather.data.temp}`
                }

                StyledText {
                    text: "°"
                }
                StyledText {
                    text: "C"
                }
            }
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    WeatherPopup {
        id: weatherPopup
        hoverTarget: mouseArea
    }
}
