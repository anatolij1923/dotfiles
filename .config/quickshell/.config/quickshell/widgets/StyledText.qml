import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.config

Text {
    id: root

    property string animateProp: "scale"
    property real animateFrom: 0
    property real animateTo: 1
    property int animateDuration: Appearance.animDuration.smaller
    property int size: Appearance.font.size.normal

    property int weight: 400
    property bool animate: false

    Behavior on color {
        CAnim {}
    }

    Behavior on text {
        enabled: root.animate
        SequentialAnimation {
            NumberAnimation {
                target: root
                property: root.animateProp
                from: root.animateFrom
                to: root.animateTo
                duration: root.animateDuration / 2
                easing.bezierCurve: Appearance.animCurves.standardAccel
            }
            NumberAnimation {
                target: root
                property: root.animateProp
                from: root.animateFrom
                to: root.animateTo
                duration: root.animateDuration / 2
                easing.bezierCurve: Appearance.animCurves.standardDecel
            }
        }
    }

    Layout.alignment: Qt.AlignVCenter
    font.family: Config.appearance.fonts.main
    font.weight: weight
    font.pixelSize: size
    font.variableAxes: {
        "wght": root.weight
    }
    color: Colors.palette.m3onSurface
    renderType: Text.NativeRendering
}
