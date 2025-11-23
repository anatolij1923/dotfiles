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
    implicitHeight: Config.bar.height
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
    }

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: clock.left
            rightMargin: 4
        }
        UsageInfo {}
    }

    ClockWidget {
        id: clock
        anchors.centerIn: parent
    }

    RowLayout {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: clock.right
            leftMargin: 4
        }
        WeatherWidget {}
    }

    RowLayout {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            rightMargin: 24
        }
        spacing: 8

        Tray {}
        QsButton {}
        BatteryWidget {}
    }
}
