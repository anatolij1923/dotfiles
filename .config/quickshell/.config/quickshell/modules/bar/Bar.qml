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
}
