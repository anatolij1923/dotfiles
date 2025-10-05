import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.modules.common

Button {
    id: button
    property string buttonIcon
    property string buttonText
    property bool keyboardDown: false
    padding: 16

    background: Rectangle {
        color: button.hovered ? Colors.surface_variant : (button.focus ? Colors.primary : Colors.surface_container)
        radius: 28

    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            keyboardDown = true;
            button.clicked();
            event.accepted = true;
        }
    }
    Keys.onReleased: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            keyboardDown = false;
            event.accepted = true;
        }
    }

    contentItem: ColumnLayout {
        anchors.centerIn: parent

        MaterialSymbol {
            Layout.alignment: Qt.AlignHCenter
            icon: button.buttonIcon
            size: 56
            weight: 700
            // color: Colors.on_surface
            color: button.focus ? Colors.surface : Colors.on_surface
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter

            text: button.buttonText
            color: button.focus ? Colors.surface : Colors.on_surface
            weight: 600
        }
    }
}
