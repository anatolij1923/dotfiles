import Quickshell
import QtQuick
import qs.common
import qs.widgets
import qs.services
import qs

Rectangle {
    id: root
    property alias text: label.text
    property alias textSize: label.size
    property bool hovered: stateLayer.containsMouse

    property bool checked: false
    property bool toggle: false
    property bool enabled: true
    property bool internalChecked: checked

    property color inactiveColor: Colors.palette.m3surfaceContainer
    property color inactiveOnColor: Colors.palette.m3onSurface
    property color activeColor: Colors.palette.m3primary
    property color activeOnColor: Colors.palette.m3surface

    property real padding: Appearance.spacing.sm
    property real horizontalPadding: padding
    property real verticalPadding: padding

    readonly property real pressedRadius: Appearance.rounding.md

    signal clicked
    signal rightClicked
    signal middleClicked
    signal held

    onCheckedChanged: internalChecked = checked

    radius: {
        if (stateLayer.pressed) {
            return pressedRadius;
        }
        return internalChecked ? Appearance.rounding.xl : implicitHeight / 2;
    }

    Behavior on radius {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    color: root.enabled ? (root.internalChecked ? root.activeColor : root.inactiveColor) : Qt.alpha(root.inactiveColor, 0.5)
    Behavior on color {
        CAnim {}
    }

    implicitWidth: label.implicitWidth + horizontalPadding * 2.5
    implicitHeight: label.implicitHeight + verticalPadding * 2

    StateLayer {
        id: stateLayer
        anchors.fill: parent
        color: root.internalChecked ? root.activeOnColor : root.inactiveOnColor
        disabled: !root.enabled

        onEntered: root.hovered = true
        onExited: root.hovered = false
        onRightClicked: root.rightClicked()
        onMiddleClicked: root.middleClicked()
        onHeld: root.held()

        function onClicked(): void {
            if (root.toggle)
                root.internalChecked = !root.internalChecked;
            root.clicked();
        }
    }

    StyledText {
        id: label
        anchors.centerIn: parent
        color: root.internalChecked ? root.activeOnColor : root.inactiveOnColor
        opacity: root.enabled ? 1.0 : 0.5
    }
}
