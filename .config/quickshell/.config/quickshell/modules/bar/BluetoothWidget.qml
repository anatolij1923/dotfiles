import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

// FIXME: prolly a bad idea to wrap it into mouse area cuz i cant toggle qsButton when hovered bluetooth widget

MouseArea {
    id: root
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight
    hoverEnabled: true

    RowLayout {
        id: content
        MaterialSymbol {
            id: icon
            icon: BluetoothService.icon
            color: Colors.palette.m3onSurface
        }

        BatteryProgress {
            visible: BluetoothService.connected
            implicitHeight: parent.height
            implicitWidth: 4
            battery: BluetoothService.battery
        }

        StyledText {
            text: ` ${BluetoothService.battery * 100}%`
            visible: root.containsMouse
            weight: 500
        }
    }

    component BatteryProgress: Item {
        id: batteryProgress
        required property real battery

        ClippingRectangle {
            id: bg
            anchors.fill: parent
            color: Colors.palette.m3surfaceBright
            radius: Appearance.rounding.full

            Rectangle {
                id: fill

                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                color: Colors.palette.m3primary
                radius: Appearance.rounding.full

                height: batteryProgress.battery * parent.height

                Behavior on height {
                    Anim {}
                }
            }
        }
    }
}
