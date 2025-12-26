import Quickshell
import Quickshell.Widgets
import QtQuick
import qs
import qs.modules.common
import qs.services
import Qt5Compat.GraphicalEffects

// TODO: Add support for others distros
Rectangle {
    id: root

    implicitWidth: implicitHeight
    implicitHeight: parent.height - 8

    color: GlobalStates.launcherOpened ? Qt.alpha(Colors.palette.m3primary, 0.3) : "transparent"
    Behavior on color {
        CAnim {}
    }

    radius: Appearance.rounding.normal

    property url iconPath: Quickshell.shellPath("assets/arch.svg")

    StateLayer {
        anchors.fill: parent
        onClicked: {
            GlobalStates.launcherOpened = true;
        }
    }

    IconImage {
        id: icon
        anchors.centerIn: parent
        source: Qt.resolvedUrl(root.iconPath)
        implicitSize: 28

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
