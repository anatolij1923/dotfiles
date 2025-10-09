import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
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
            leftMargin: 16
            rightMargin: 16
            fill: parent
        }
        spacing: 16

        Workspaces {}
        // // FocusedWindow {}
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
        Tray {}
        KbLayout {}
        NetworkWidget {}
        Battery {}
    }
}
