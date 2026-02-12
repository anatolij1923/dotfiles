import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets

StatusPillWidget {
    icon: BluetoothService.icon

    BatteryProgress {
        visible: BluetoothService.connected
        implicitHeight: parent.height * 0.85
        implicitWidth: 6
        battery: BluetoothService.battery
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
                color: Colors.palette.m3secondary
                radius: Appearance.rounding.full

                height: batteryProgress.battery * parent.height

                Behavior on height {
                    Anim {}
                }
            }
        }
    }
}
