import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs

PopupWindow {
    id: root

    signal menuOpened(qsWindow: var)
    signal menuClosed

    implicitWidth: 100
    implicitHeight: 100

    function open() {
        root.visible = true;
        root.menuOpened(root);
    }

    function close() {
        root.visible = false;
        while (stackView.depth > 1)
            stackView.pop();
        root.menuClosed();
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton | Qt.RightButton
        onPressed: event => {
            if ((event.button === Qt.BackButton || event.button === Qt.RightButton) && stackView.depth > 1)
                stackView.pop();
        }

        Rectangle {
            id: popupBg
            anchors.fill: parent

            color: Colors.primary
        }
    }
}
