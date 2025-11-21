import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.corners

PanelWindow {
    id: root
    color: "transparent"
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }
    exclusionMode: ExclusionMode.Auto
    WlrLayershell.namespace: "quickshell:corners"
    mask: Region {}

    Corners {
        corners: [0, 1]
        cornerHeight: 30
        cornerType: "inverted"
        color: Colors.palette.m3surface
    }
}
