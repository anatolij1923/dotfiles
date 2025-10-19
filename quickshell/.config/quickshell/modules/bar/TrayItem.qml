import Quickshell
import QtQuick
import Quickshell.Services.SystemTray

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

    Image {
        id: icon
        anchors.centerIn: parent
        source: root.modelData.icon 
        width: 18
        height: 18
    }
}
