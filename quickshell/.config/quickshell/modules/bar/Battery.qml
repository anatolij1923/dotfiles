import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import qs
import qs.modules.common

Item {
    id: root
    property string battery: UPower.displayDevice.isLaptopBattery ? (Math.round(UPower.displayDevice.percentage * 100)) + "" : "0%"
    property string icon: {
        if (!UPower.onBattery)
            return "bolt";
        return "";
    }

    visible: UPower.displayDevice.isLaptopBattery
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
            width: root.battery * parent.width / 100
            radius: 4
            color: root.battery >= 25 ? Colors.on_secondary_container : Colors.error

            Behavior on color {
                ColorAnimation {
                    duration: 2000
                    easing.type: Easing.OutCubic
                }
            }
        }

        MaterialSymbol {
            id: icon
            visible: root.icon !== ""
            icon: root.icon
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 2
            font.pixelSize: 18
            font.weight: 600
            fill: 1
        }

        StyledText {
            id: text
            text: root.battery
            color: Colors.surface
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: icon.visible ? 4 : 0
            font.weight: 600
        }

        // RowLayout {
        //     anchors.fill: parent
        //     anchors.centerIn: parent
        //     spacing: 0
        //
        //     MaterialSymbol {
        //         icon: root.icon
        //         anchors.verticalCenter: parent.verticalCenter
        //         font.pixelSize: 24
        //     }
        //
        //     StyledText {
        //         id: text
        //         text: root.battery
        //         color: Colors.surface
        //         font.weight: 600
        //     }
        // }
    }
}
