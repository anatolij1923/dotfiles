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

    VerticalProgressbar {
        visible: BluetoothService.connected
        value: BluetoothService.battery
        fillColor: value >= 0.2 ? Colors.palette.m3secondary : "#ff5050"
        implicitHeight: parent.height * 0.85
    }
}
