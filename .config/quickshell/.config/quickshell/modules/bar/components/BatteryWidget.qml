pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services
import qs.common
import qs.widgets

ClippingRectangle {
    id: root

    property bool showPopup

    implicitWidth: 50
    implicitHeight: 28

    radius: Appearance.rounding.full
    color: "transparent"
    // color: Colors.palette.m3outlineVariant
    border {
        width: 2
        color: Colors.palette.m3onSecondaryContainer
    }

    StyledText {
        id: bgText
        anchors.centerIn: parent
        text: Battery.percentage
        color: Colors.palette.m3onSecondaryContainer
        weight: 650
    }

    ClippingRectangle {
        anchors {
            fill: parent
            margins: Config.bar.battery.margins
        }
        radius: Appearance.rounding.full
        color: "transparent"

        ClippingRectangle {
            id: fill
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }

            implicitWidth: parent.width * (Battery.percentage / 100)

            radius: Appearance.rounding.xs
            color: Colors.palette.m3onSecondaryContainer

            Behavior on color {
                CAnim {}
            }

            StyledText {
                text: bgText.text
                color: Colors.palette.m3surface
                weight: bgText.weight

                x: bgText.x - Config.bar.battery.margins
                y: bgText.y - Config.bar.battery.margins
            }
        }
    }

    states: [
        State {
            name: "charging"
            when: Battery.isCharging
            PropertyChanges {
                target: fill
                color: Colors.mix(Colors.palette.m3primary, "#58e046", 0.5)
            }
        },
        State {
            name: "low"
            when: Battery.percentage <= Config.battery.low
            PropertyChanges {
                target: fill
                color: Colors.palette.m3error
            }
        }
    ]

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
