pragma ComponentBehavior: Bound
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

    implicitWidth: 48
    implicitHeight: 26

    radius: Appearance.rounding.full
    color: Colors.palette.m3outline

    Rectangle {
        id: fill
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }

        implicitWidth: parent.width * (Battery.percentage / 100)

        // bottomRightRadius: Appearance.rounding.xs
        // topRightRadius: Appearance.rounding.xs

        color: Colors.palette.m3onSecondaryContainer
        Behavior on color {
            CAnim {}
        }
    }

    StyledText {
        id: bgText
        anchors.centerIn: parent
        text: Battery.percentage
        color: Colors.palette.m3surface
        weight: 500
    }

    states: [
        State {
            name: "charging"
            when: Battery.isCharging
            PropertyChanges {
                target: fill
                color: Colors.mix(Colors.palette.m3primary, "#58e046", 0.7)
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
