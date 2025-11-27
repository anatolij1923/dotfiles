import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.corners
import qs.modules.common
import qs.config

PanelWindow {
    id: root
    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled
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
        color: root.transparent ? Qt.alpha(Colors.palette.m3surface, root.alpha) : Colors.palette.m3surface
        Behavior on color {
            CAnim {}
        }
    }
}
