pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import qs.common
import qs.widgets
import qs.config

Rectangle {
    id: root
    required property SystemTrayItem modelData
    signal openMenuRequested(var handle, int x, int y, int w, int h)

    color: "transparent"
    radius: Appearance.rounding.md

    implicitWidth: 28
    implicitHeight: 28

    StateLayer {
        anchors.fill: parent
        onClicked: event => {
            if (event.button === Qt.LeftButton) {
                root.modelData.activate();
            } else {
                const pos = root.mapToGlobal(0, 0);
                root.openMenuRequested(root.modelData.menu, pos.x, pos.y, root.width, root.height);
            }
        }
    }

    IconImage {
        id: icon
        anchors.centerIn: parent
        source: Icons.getTrayIcon(root.modelData.id, root.modelData.icon)
        implicitSize: parent.height * 0.8
        visible: !Config.bar.tray.monochromeTrayIcons
    }

    Loader {
        active: Config.bar.tray.monochromeTrayIcons
        anchors.fill: icon
        sourceComponent: Desaturate {
            anchors.fill: parent
            source: icon
            desaturation: Config.bar.tray.desaturation
        }
    }
}
