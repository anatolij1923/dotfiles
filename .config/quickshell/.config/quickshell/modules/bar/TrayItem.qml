import Quickshell
import Quickshell.Widgets
import QtQuick
import Quickshell.Services.SystemTray
import qs.utils

MouseArea {
    id: root

    required property SystemTrayItem modelData

    implicitWidth: 20
    implicitHeight: 20

    onClicked: event => {
        if (event.button === Qt.LeftButton)
            modelData.display(null, x, y);
        else
            modelData.display()
    }

    IconImage {
        id: icon
        anchors.centerIn: parent
        source: Icons.getTrayIcon(root.modelData.id, root.modelData.icon)
        width: 18
        height: 18
    }
}
