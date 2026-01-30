import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

BarPopup {
    id: root
    padding: Appearance.padding.larger

    ColumnLayout {
        spacing: 12

        StyledText {
            text: Weather.data.city
            size: 22
            weight: 600
            Layout.alignment: Qt.AlignHCenter
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 15

            MaterialSymbol {
                icon: Weather.data.icon
                font.pixelSize: 48
                color: Colors.palette.m3primary
            }

            ColumnLayout {
                spacing: 0
                StyledText {
                    text: Weather.data.temp + "°"
                    size: 42
                    weight: 300
                }
                StyledText {
                    text: Weather.data.desc
                    color: Colors.palette.m3secondary
                    size: 16
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        GridLayout {
            columns: 2
            Layout.fillWidth: true
            columnSpacing: 20
            rowSpacing: 10

            RowLayout {
                spacing: 8
                MaterialSymbol {
                    icon: "thermostat"
                    color: Colors.palette.m3secondary
                }
                StyledText {
                    text: "Feels like " + Weather.data.tempFeelsLike + "°"
                }
            }

            RowLayout {
                spacing: 8
                MaterialSymbol {
                    icon: "air"
                    color: Colors.palette.m3secondary
                }
                StyledText {
                    text: Weather.data.wind + " km/h"
                }
            }

            RowLayout {
                spacing: 8
                MaterialSymbol {
                    icon: "vertical_align_center"
                    color: Colors.palette.m3secondary
                }
                StyledText {
                    text: "L: " + Weather.data.minTemp + "°  H: " + Weather.data.maxTemp + "°"
                }
            }

            RowLayout {
                spacing: 8
                MaterialSymbol {
                    icon: "water_drop"
                    color: Colors.palette.m3secondary
                }
                StyledText {
                    text: Weather.data.humidity + "%"
                }
            }
        }
    }
}
