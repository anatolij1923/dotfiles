pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import qs.common
import qs.widgets

Item {
    id: root
    property int percentage: Battery.percentage
    property bool isCharging: Battery.isCharging
    property bool useClassicStyle: Config.bar.battery.classicBatteryStyle
    property bool showPopup

    implicitWidth: batteryLoader.item ? batteryLoader.item.implicitWidth : 0
    implicitHeight: batteryLoader.item ? batteryLoader.item.implicitHeight : 0

    Loader {
        id: batteryLoader
        anchors.centerIn: parent
        sourceComponent: Battery.available && root.useClassicStyle ? classicComp : pillComp
    }

    Component {
        id: classicComp
        ClassicBattery {}
    }

    Component {
        id: pillComp
        PillShapeBattery {}
    }

    component ClassicBattery: Item {
        id: classicBatteryRoot
        implicitHeight: classicBatteryContent.implicitHeight
        implicitWidth: classicBatteryContent.implicitWidth

        RowLayout {
            id: classicBatteryContent
            anchors.fill: parent
            spacing: Appearance.spacing.sm

            StyledText {
                text: `${root.percentage}%`
                size: 18

                visible: Config.bar.battery.showPercentage
            }

            RowLayout {
                id: classicBatteryLayout
                spacing: 2

                Item {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 22

                    ClippingRectangle {
                        id: classicBatteryContainer
                        anchors.fill: parent
                        color: "transparent"
                        radius: Appearance.rounding.sm
                        border {
                            width: 2
                            color: Colors.palette.m3onSecondaryContainer
                        }

                        Item {
                            id: innerArea
                            anchors.fill: parent
                            anchors.margins: 2

                            Rectangle {
                                id: fill
                                color: root.isCharging ? Colors.palette.m3primary : (root.percentage <= Config.battery.low ? Colors.palette.m3error : Colors.palette.m3onSecondaryContainer)

                                Behavior on color {
                                    CAnim {}
                                }

                                radius: classicBatteryContainer.radius * 0.5

                                anchors {
                                    left: parent.left
                                    top: parent.top
                                    bottom: parent.bottom
                                }

                                width: parent.width * (root.percentage / 100)

                                Behavior on width {
                                    Anim {}
                                }
                            }
                        }
                    }

                    MaterialSymbol {
                        icon: "bolt"
                        fill: 1
                        size: 20
                        anchors.centerIn: parent
                        color: root.isCharging ? Colors.palette.m3primary : Colors.palette.m3onSecondaryContainer
                        visible: root.isCharging
                    }

                    Item {
                        id: iconMask
                        anchors {
                            left: classicBatteryContainer.left
                            top: classicBatteryContainer.top
                            bottom: classicBatteryContainer.bottom
                            leftMargin: 2
                        }
                        width: fill.width
                        clip: true
                        visible: root.isCharging

                        MaterialSymbol {
                            icon: "bolt"
                            fill: 1
                            size: 20
                            x: (classicBatteryContainer.width / 2) - (width / 2) - 2
                            y: (classicBatteryContainer.height / 2) - (height / 2)

                            color: Colors.palette.m3surface
                        }
                    }
                }

                Rectangle {
                    color: Colors.palette.m3onSecondaryContainer
                    radius: Appearance.rounding.sm
                    Layout.preferredHeight: classicBatteryContainer.height * 0.42
                    Layout.preferredWidth: 3
                }
            }
        }
    }

    component PillShapeBattery: Item {
        id: pillShapeBatteryRoot

        property int radius: Appearance.rounding.full

        implicitWidth: pillShapeBatteryBackground.width
        implicitHeight: pillShapeBatteryBackground.height

        Layout.alignment: Qt.AlignVCenter
        ClippingRectangle {
            id: pillShapeBatteryBackground
            anchors.fill: parent
            width: 55
            height: 25
            color: Colors.palette.m3outline
            radius: pillShapeBatteryRoot.radius

            Rectangle {
                id: bar
                clip: true
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: Battery.percentage * parent.width / 100
                radius: Appearance.rounding.sm
                color: Battery.isCharging ? Colors.palette.m3primary : (Battery.percentage > Config.battery.low ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3error)

                Behavior on color {
                    CAnim {}
                }
            }

            MaterialSymbol {
                id: icon
                visible: Battery.isCharging
                icon: "bolt"
                color: Colors.palette.m3surface
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 2
                size: 18
                weight: 600
                fill: 1
            }

            StyledText {
                id: text
                text: root.percentage
                color: Colors.palette.m3surface
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: icon.visible ? 4 : 0
                weight: 600
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }

    BatteryPopup {
        id: batteryPopup
        hoverTarget: root.showPopup && mouseArea
    }
}
