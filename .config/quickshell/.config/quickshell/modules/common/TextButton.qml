import Quickshell
import QtQuick
import qs.modules.common
import qs.services
import qs

Rectangle {
    id: root
    property alias text: label.text
    property alias size: label.size
    property bool hovered: stateLayer.hovered

    property bool checked: false
    property bool toggle: false
    property bool enabled: true
    property bool internalChecked

    property real padding: Appearance.padding.small
    property color inactiveColor: Colors.palette.m3surfaceContainer
    property color inactiveOnColor: Colors.palette.m3onSurface
    property color activeColor: Colors.palette.m3primary
    property color activeOnColor: Colors.palette.m3surface

    property alias stateLayer: stateLayer

    signal clicked
    signal rightClicked
    signal middleClicked

    onCheckedChanged: internalChecked = checked

    radius: internalChecked ? Appearance.rounding.normal : implicitHeight / 2

    color: root.enabled ? (root.internalChecked ? root.activeColor : root.inactiveColor) : Qt.alpha(root.inactiveColor, 0.5)

    implicitWidth: label.implicitWidth + padding * 2
    implicitHeight: label.implicitHeight + padding * 2

    StateLayer {
        id: stateLayer
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

    StyledText {
        id: label
        anchors.centerIn: parent
        color: root.internalChecked ? root.activeOnColor : root.inactiveOnColor
    }

    // MaterialSymbol {
    //     id: label
    //     anchors.centerIn: parent
    //     color: root.internalChecked ? root.activeOnColor : root.inactiveOnColor
    //     fill: root.internalChecked ? 1 : 0
    //
    //     Behavior on fill {
    //         Anim {
    //             duration: Appearance.animDuration.small
    //         }
    //     }
    // }
}
