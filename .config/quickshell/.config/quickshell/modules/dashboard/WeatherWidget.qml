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
    property bool expanded: false

    readonly property var forecastModel: Weather.data.forecast

    Item {
        id: leftSide

        anchors {
            left: parent.left
        }

        implicitHeight: parent.height
        implicitWidth: implicitHeight

        ColumnLayout {
            id: mainInfo

            anchors.centerIn: parent

            MaterialSymbol {
                icon: `${Weather.data.icon}`
                color: Colors.palette.m3primary
                size: root.expanded ? 72 : 84

                Behavior on size {
                    Anim {}
                }
                Layout.alignment: Qt.AlignHCenter
            }
            StyledText {
                text: `${Weather.data.temp}°`
                weight: 600
                size: Appearance.fontSize.xxl
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    Item {
        id: rightSide
        visible: opacity > 0
        opacity: root.expanded ? 1 : 0

        Behavior on opacity {
            Anim {}
        }

        anchors {
            left: root.expanded ? leftSide.right : undefined
            right: root.expanded ? parent.right : undefined
            top: parent.top
            bottom: parent.bottom
        }

        Item {
            id: forecast

            anchors {
                top: rightSide.top
                right: info.left
                bottom: rightSide.bottom
                left: parent.left
            }

            Row {
                anchors.centerIn: parent
                spacing: Appearance.spacing.md

                Repeater {
                    model: root.forecastModel

                    delegate: Item {
                        id: dayItem
                        required property var modelData
                        implicitWidth: dayItemContent.implicitWidth
                        implicitHeight: dayItemContent.implicitHeight

                        Column {
                            id: dayItemContent
                            anchors.centerIn: parent
                            spacing: Appearance.spacing.md
                            StyledText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: dayItem.modelData.day
                                size: Appearance.fontSize.lg
                                weight: 500
                            }

                            MaterialSymbol {
                                icon: dayItem.modelData.icon
                                color: Colors.palette.m3secondary
                                size: 40
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            StyledText {
                                text: dayItem.modelData.avg + "°"
                                size: Appearance.fontSize.md
                                weight: 450
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }
        }

        ColumnLayout {
            id: info
            anchors {
                top: parent.top
                right: parent.right
                margins: Appearance.spacing.lg
            }

            StyledText {
                text: `${Weather.data.city}`
                Layout.alignment: Qt.AlignRight
                size: Appearance.fontSize.lg
                color: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.4)
            }
            StyledText {
                Layout.alignment: Qt.AlignRight
                text: Weather.data.desc || "Loading..."
                size: Appearance.fontSize.xl
                color: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.4)
                weight: 500
            }
            StyledText {
                size: Appearance.fontSize.lg
                Layout.alignment: Qt.AlignRight
                text: `Feels like: ${Weather.data.tempFeelsLike}°`
            }

            StyledText {
                Layout.alignment: Qt.AlignRight
                text: `Humidity: ${Weather.data.humidity}%`
                size: Appearance.fontSize.lg
            }

            Row {
                Layout.alignment: Qt.AlignRight
                spacing: 4
                StyledText {
                    text: `${Weather.data.maxTemp}°`
                    weight: 450
                }

                StyledText {
                    text: `•`
                    opacity: 0.7
                    weight: 450
                }

                StyledText {
                    text: `${Weather.data.minTemp}°`
                    opacity: 0.7
                    weight: 450
                }
            }
        }
    }
}
