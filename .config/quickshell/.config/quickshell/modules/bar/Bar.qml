import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services
import qs.config
import qs

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: Appearance.sizes.barHeight
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell:bar"
    color: Colors.palette.m3surface
    property bool e: Config.bar

    RowLayout {
        anchors {
            left: parent.left
            leftMargin: 24
            verticalCenter: parent.verticalCenter
        }
        spacing: 8

        Workspaces {}
        UsageInfo {}
    }

    ClockWidget {
        anchors.centerIn: parent
    }

    RowLayout {
        anchors {
            right: parent.right
            rightMargin: 24
            verticalCenter: parent.verticalCenter
        }
        spacing: 8

        WeatherWidget {}
        KbLayout {}
        Tray {}
        QsButton {}
        BatteryWidget {}
    }
}
