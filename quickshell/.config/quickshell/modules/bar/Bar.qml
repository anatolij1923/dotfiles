import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: 50
    WlrLayershell.layer: WlrLayer.Top
    color: Colors.surface

    RowLayout {
        anchors {
            leftMargin: 24
            rightMargin: 24
            fill: parent
        }
        spacing: 8

        Workspaces {}
        // FocusedWindow {}
        Item {
            Layout.fillWidth: true
        }
        ClockWidget {
            anchors.horizontalCenter: parent.horizontalCenter
            // Layout.alignment: Qt.AlignCenter
        }
        Item {
            Layout.fillWidth: true
        }
        // test buttons
        // RippleButton {
        //     toggled: true
        //     buttonText: "fdsg"
        //     implicitHeight: parent.implicitHeight
        //     implicitWidth: 50
        // }
        // RippleButton {
        //     buttonText: "fdsg"
        //     implicitHeight: parent.implicitHeight
        //     implicitWidth: 50
        // }

        KbLayout {}
        Tray {}
        // NetworkWidget {}
        // BluetoothWidget {}
        QsButton {}
        BatteryWidget {}
    }
}
