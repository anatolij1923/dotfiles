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
    // color: Colors.palette.m3surface

    property real alpha: Config.ready && Config.appearance.transparency.alpha
    property bool transparent: Config.ready && Config.appearance.transparency.enabled

    color: transparent ? Qt.alpha(Colors.palette.m3surface, alpha) : Colors.palette.m3surface
    Behavior on color {
        CAnim {}
    }

    property bool e: Config.bar

    Component.onCompleted: {
        console.log("[BAR TRANSPARECNY] " + transparent);
    }

    RowLayout {
        id: ws
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: 24
        }
        spacing: 8

        Workspaces {}
    }

    Item {
        anchors {
            left: ws.right
            right: usage.left
            top: parent.top
            bottom: parent.bottom
        }

        Loader {
            active: !!Players.active
            anchors.centerIn: parent

            sourceComponent: Media {}
        }
    }

    RowLayout {
        id: usage
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

        RecordWidget {}
        Tray {}
        QsButton {}
        BatteryWidget {}
    }
}
