import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

Item {
    id: root

    visible: Battery.available
    implicitWidth: background.width
    implicitHeight: background.height

    Layout.alignment: Qt.AlignVCenter
    ClippingRectangle {
        id: background
        anchors.fill: parent
        width: 55
        height: 25
        color: Colors.outline
        radius: 16

        Rectangle {
            id: bar
            clip: true
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: Battery.percentage * parent.width / 100
            radius: 4
            color: Battery.isCharging ? Colors.primary : (Battery.percentage >= 25 ? Colors.on_secondary_container : Colors.error)

            Behavior on color {
                ColorAnimation {
                    duration: 2000
                    easing.type: Easing.OutCubic
                }
            }
        }

        MaterialSymbol {
            id: icon
            visible: Battery.isCharging
            icon: "bolt"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 2
            font.pixelSize: 18
            font.weight: 600
            fill: 1
        }

        StyledText {
            id: text
            text: Battery.percentage
            color: Colors.surface
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: icon.visible ? 4 : 0
            font.weight: 600
        }
    }
}
