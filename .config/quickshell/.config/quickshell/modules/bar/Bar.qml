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
            top: parent.top
            bottom: parent.bottom
            leftMargin: 24
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
            top: parent.top
            bottom: parent.bottom
            rightMargin: 24
        }
        spacing: 8

        WeatherWidget {}
        Tray {}
        QsButton {}
        BatteryWidget {}
    }
}
