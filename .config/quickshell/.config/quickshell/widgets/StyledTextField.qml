pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.config
import qs.services

TextField {
    id: root

    property string placeholder: "Type..."
    property int fontSize: 16
    property int fontWeight: 500

    // verticalAlignment: TextInput.AlignVCenter
    background: null
    color: Colors.palette.m3onSurface
    placeholderText: placeholder
    placeholderTextColor: Colors.palette.m3onSurface
    font.pixelSize: root.fontSize
    font.family: Config.appearance.fonts.main
    font.weight: root.fontWeight
    font.hintingPreference: Font.PreferFullHinting
    font.variableAxes: {
        "wght": root.fontWeight
    }
    renderType: Text.NativeRendering

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
}
