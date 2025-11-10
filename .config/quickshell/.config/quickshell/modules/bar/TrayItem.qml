import Quickshell
import Quickshell.Widgets
import QtQuick
import Quickshell.Services.SystemTray
import qs.utils
import qs.modules.common
import qs.services

MouseArea {
    id: root

    required property SystemTrayItem modelData

    signal menuOpened(qsWindow: var)
    signal menuClosed

    acceptedButtons: Qt.LeftButton | Qt.RightButton

    property int padding: Appearance.padding.small

    implicitWidth: 20 + padding * 2
    implicitHeight: 20 + padding * 2

    hoverEnabled: true

    onPressed: event => {
        switch (event.button) {
        case Qt.LeftButton:
            item.activate();
            break;
        case Qt.RightButton:
            if (item.hasMenu)
                menu.open();
            break;
        }
        event.accepted = true;
    }

    // onEntered:

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            modelData.display(null, x, y);
        } else
            modelData.display();
    }

    IconImage {
        id: icon
        anchors.centerIn: parent
        source: Icons.getTrayIcon(root.modelData.id, root.modelData.icon)
        asynchronous: true
        width: parent.width - 8
        height: parent.height - 8
    }
}
