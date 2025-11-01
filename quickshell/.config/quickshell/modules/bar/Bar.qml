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
    implicitHeight: Appearance.sizes.barHeight
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
        UsageInfo {}
        Item {
            Layout.fillWidth: true
        }
        ClockWidget {
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Item {
            Layout.fillWidth: true
        }

        KbLayout {}
        Tray {}
        QsButton {}
        BatteryWidget {}
    }
}
