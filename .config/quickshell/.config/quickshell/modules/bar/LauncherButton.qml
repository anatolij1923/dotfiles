import QtQuick
import qs.widgets
import qs.services
import qs
import qs.common

Rectangle {
    id: root

    property int padding: Appearance.padding.smaller
    property bool launcherOpened

    Connections {
        target: GlobalStates
        function onLauncherOpenedChanged() {
            root.launcherOpened = !root.launcherOpened;
        }
    }

    implicitWidth: icon.implicitWidth + padding * 2
    implicitHeight: implicitWidth

    color: root.launcherOpened ? Colors.palette.m3secondaryContainer : "transparent"

    Behavior on color {
        CAnim {}
    }

    radius: Appearance.rounding.small

    StateLayer {
        anchors.fill: parent
        onClicked: GlobalStates.launcherOpened = true
    }

    MaterialSymbol {
        id: icon
        anchors.centerIn: parent
        icon: "apps"
        size: 28
        color: root.launcherOpened ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
    }
}
