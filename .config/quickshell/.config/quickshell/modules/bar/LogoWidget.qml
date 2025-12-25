import Quickshell
import Quickshell.Widgets
import QtQuick
import qs.modules.common
import qs.services
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    color: "transparent"
    property url iconPath: Quickshell.shellPath("assets/arch.svg")

    StateLayer {
        anchors.fill: parent
    }

    IconImage {
        id: icon
        anchors.centerIn: parent
        source: Qt.resolvedUrl(root.iconPath)
        implicitSize: 32

        Component.onCompleted: {
            console.log("sdjlvjldsn");
        }
    }

    ColorOverlay {
        anchors.fill: icon
        source: icon
        color: Colors.palette.m3secondary
    }
}
