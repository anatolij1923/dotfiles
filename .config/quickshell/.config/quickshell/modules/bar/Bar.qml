import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.services
import qs.config
import qs.widgets

StyledWindow {
    id: root

    name: "bar"

    anchors {
        top: !Config.bar.bottom
        bottom: Config.bar.bottom
        left: true
        right: true
    }

    implicitHeight: Config.bar.height
    WlrLayershell.layer: WlrLayer.Top

    color: "transparent"
    Behavior on color {
        CAnim {}
    }

    property bool floating: Config.bar.floating
    property bool bottom: Config.bar.bottom
    property var m: Config.bar.margins

    Loader {
        active: true
        anchors {
            fill: parent
            topMargin: root.floating && !root.bottom ? root.m.vertical : 0
            bottomMargin: root.floating && root.bottom ? root.m.vertical : 0
            leftMargin: root.floating ? root.m.horizontal : 0
            rightMargin: root.floating ? root.m.horizontal : 0
        }
        sourceComponent: BarContent {}
    }

    // RowLayout {
    //     id: ws
    //     anchors {
    //         left: parent.left
    //         top: parent.top
    //         bottom: parent.bottom
    //         leftMargin: 24
    //     }
    //     spacing: 8
    //
    //     Workspaces {}
    // }
    //
    // Item {
    //     anchors {
    //         left: ws.right
    //         right: usage.left
    //         top: parent.top
    //         bottom: parent.bottom
    //     }
    //
    //     Loader {
    //         active: !!Players.active
    //         anchors.centerIn: parent
    //
    //         sourceComponent: Media {}
    //     }
    // }
    //
    // RowLayout {
    //     id: usage
    //     anchors {
    //         top: parent.top
    //         bottom: parent.bottom
    //         right: clock.left
    //         rightMargin: 4
    //     }
    //     UsageInfo {}
    // }
    //
    // ClockWidget {
    //     id: clock
    //     anchors.centerIn: parent
    // }
    //
    // RowLayout {
    //     anchors {
    //         top: parent.top
    //         bottom: parent.bottom
    //         left: clock.right
    //         leftMargin: 4
    //     }
    //     WeatherWidget {}
    // }
    //
    // RowLayout {
    //     anchors {
    //         right: parent.right
    //         top: parent.top
    //         bottom: parent.bottom
    //         rightMargin: 24
    //     }
    //     spacing: 8
    //
    //     RecordWidget {}
    //     Tray {}
    //     QsButton {}
    //     BatteryWidget {}
    // }
}
