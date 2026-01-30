import Quickshell
import QtQuick
import qs.common
import qs.widgets
import qs.services
import qs

Rectangle {
    id: root
    property alias icon: label.icon
    property alias iconSize: label.size
    property bool hovered: stateLayer.containsMouse

    property bool checked: false
    property bool toggle: false
    property bool enabled: true
    property bool internalChecked: checked

    property real padding: Appearance.padding.smaller
    property real horizontalPadding: padding
    property real verticalPadding: padding

    property color inactiveColor: Colors.palette.m3surfaceContainer
    property color inactiveOnColor: Colors.palette.m3onSurface
    property color activeColor: Colors.palette.m3primary
    property color activeOnColor: Colors.palette.m3onPrimary

    readonly property real pressedRadius: Appearance.rounding.small

    property alias stateLayer: stateLayer

    signal clicked
    signal rightClicked
    signal middleClicked

    onCheckedChanged: internalChecked = checked

    radius: {
        if (stateLayer.pressed)
            return root.pressedRadius;
        return internalChecked ? Appearance.rounding.large : height / 2;
    }

    Behavior on radius {
        Anim {
            duration: Appearance.animDuration.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
        }
    }

    color: root.enabled ? (root.internalChecked ? root.activeColor : root.inactiveColor) : Qt.alpha(root.inactiveColor, 0.5)
    Behavior on color {
        CAnim {
            duration: Appearance.animDuration.expressiveEffects
        }
    }

    readonly property real _iconBaseSize: Math.max(label.implicitWidth, label.implicitHeight)

    implicitWidth: _iconBaseSize + horizontalPadding * 2
    implicitHeight: _iconBaseSize + verticalPadding * 2

    StateLayer {
        id: stateLayer
        anchors.fill: parent
        color: root.internalChecked ? root.activeOnColor : root.inactiveOnColor
        disabled: !root.enabled
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onRightClicked: root.rightClicked()
        onMiddleClicked: root.middleClicked()

        function onClicked(): void {
            if (root.toggle)
                root.internalChecked = !root.internalChecked;
            root.clicked();
        }
    }

    MaterialSymbol {
        id: label
        anchors.centerIn: parent
        color: root.internalChecked ? root.activeOnColor : root.inactiveOnColor
        fill: root.internalChecked ? 1 : 0
        opacity: root.enabled ? 1.0 : 0.5

        Behavior on color {
            CAnim {}
        }
        // Behavior on opacity {
        //     CAnim {}
        // }
        Behavior on fill {
            Anim {
                duration: Appearance.animDuration.expressiveEffects
                easing.type: Appearance.animCurves.emphasized
            }
        }
    }
}
