import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs

TextField {
    id: root

    property color backgroundColor: Colors.surface_container
    property real radius: 20
    property string placeholder: "Type..."
    property string icon: ""
    property real iconSize: icon === "" ? 0 : 25

    padding: 20
    focus: root.focus
    color: Colors.on_surface
    placeholderText: placeholder
    placeholderTextColor: Colors.on_surface
    font.pixelSize: 16
    font.family: "Rubik"
    font.weight: 500
    renderType: Text.NativeRendering
    leftPadding: icon !== "" ? iconSize + 35 : 20

    cursorDelegate: Rectangle {
        width: 2
        radius: 1
        color: Colors.on_surface

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation {
                from: 1
                to: 0
                duration: 1000
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                from: 0
                to: 1
                duration: 1000
                easing.type: Easing.OutCubic
            }
        }
    }

    background: Rectangle {
        id: bg
        radius: root.radius
        color: root.backgroundColor
    }
    MaterialSymbol {
        icon: root.icon
        visible: root.icon !== ""
        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }
        color: Colors.on_surface
    }
}
