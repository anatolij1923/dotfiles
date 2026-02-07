import Quickshell
import QtQuick
import qs.common
import qs.widgets
import qs.services
import qs

Rectangle {
    id: root

    property alias icon: iconItem.icon
    property alias iconSize: iconItem.size
    property alias iconColor: iconItem.color
    property alias text: label.text
    property alias textSize: label.size
    property alias textWeight: label.weight
    property alias textColor: label.color

    property alias stateLayer: stateLayer
    property bool hovered: stateLayer.containsMouse
    property bool checked: false
    property bool toggle: false
    property bool enabled: true
    property bool internalChecked: checked

    property real padding: Appearance.padding.smaller
    property real horizontalPadding: padding
    property real verticalPadding: padding
    property real spacing: Appearance.padding.small

    property color inactiveColor: Colors.palette.m3surfaceContainer
    property color inactiveOnColor: Colors.palette.m3onSurface
    property color activeColor: Colors.palette.m3primary
    property color activeOnColor: Colors.palette.m3surface

    readonly property real pressedRadius: Appearance.rounding.small

    signal clicked
    signal rightClicked
    signal middleClicked
    signal held

    onCheckedChanged: internalChecked = checked

    radius: {
        if (stateLayer.pressed) {
            return root.pressedRadius;
        }
        return internalChecked ? Appearance.rounding.large : implicitHeight / 2;
    }

    Behavior on radius {
        Anim {
            duration: Appearance.animDuration.expressiveDefaultSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
        }
    }

    color: root.enabled ? (root.internalChecked ? root.activeColor : root.inactiveColor) : Qt.alpha(root.inactiveColor, 0.5)
    Behavior on color {
        CAnim {}
    }

    implicitWidth: content.implicitWidth + horizontalPadding * 2
    implicitHeight: Math.max(iconItem.implicitHeight, label.implicitHeight) + verticalPadding * 2

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

    Row {
        id: content
        anchors.centerIn: parent
        spacing: root.spacing

        MaterialSymbol {
            id: iconItem
            anchors.verticalCenter: parent.verticalCenter
            color: root.internalChecked ? root.activeOnColor : root.inactiveOnColor
            fill: root.internalChecked ? 1 : 0

            opacity: root.enabled ? 1.0 : 0.5

            // Behavior on opacity {
            //     CAnim {}
            // }

            Behavior on fill {
                Anim {
                    duration: Appearance.animDuration.expressiveDefaultSpatial
                }
            }
        }

        StyledText {
            id: label
            anchors.verticalCenter: parent.verticalCenter
            color: root.internalChecked ? root.activeOnColor : root.inactiveOnColor

            opacity: root.enabled ? 1.0 : 0.5

            // Behavior on opacity {
            //     CAnim {}
            // }
        }
    }
}
