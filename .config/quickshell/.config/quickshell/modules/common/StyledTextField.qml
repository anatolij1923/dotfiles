pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs
import qs.services

TextField {
    id: root

    property color backgroundColor: Colors.palette.m3surfaceContainer
    property real radius: 20
    property string placeholder: "Type..."
    property string icon: ""
    property real iconSize: icon === "" ? 0 : 25
    property int fontSize: 16
    property int fontWeight: 500

    padding: 20
    focus: root.focus
    color: Colors.palette.m3onSurface
    placeholderText: placeholder
    placeholderTextColor: Colors.palette.m3onSurface
    font.pixelSize: root.fontSize
    font.family: "Rubik"
    font.variableAxes: {
        "wght": root.font.weight
    }
    font.weight: root.fontWeight
    renderType: Text.NativeRendering
    leftPadding: icon !== "" ? iconSize + 35 : 20

    cursorDelegate: Rectangle {
        width: 2
        radius: 1
        color: Colors.palette.m3onSurface
        visible: root.focus

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
        color: Colors.palette.m3onSurface
    }
}
