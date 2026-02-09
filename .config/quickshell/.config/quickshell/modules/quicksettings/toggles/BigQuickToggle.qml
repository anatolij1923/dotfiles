import qs.common
import qs.widgets
import qs.services
import qs
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property alias title: title.text
    property alias substring: substring.text
    property alias icon: button.icon
    property alias checked: button.checked
    property alias toggle: button.toggle
    property alias enabled: button.enabled
    property int padding: Appearance.spacing.md
    property string tooltipText: ""

    signal clicked
    signal rightClicked
    signal middleClicked
    signal held
    signal textAreaClicked
    signal textAreaHeld
    signal textAreaRightClicked

    radius: checked ? Appearance.rounding.xl : Appearance.rounding.full

    Behavior on radius {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    color: Colors.palette.m3surfaceContainer

    implicitWidth: content.implicitWidth + padding * 2
    implicitHeight: content.implicitHeight + padding * 2

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    Elevation {
        anchors.fill: parent
        level: 3
        z: -1
        radius: parent.radius
        opacity: 0.5
    }

    RowLayout {
        id: content
        anchors.fill: parent
        anchors.centerIn: parent
        anchors.margins: root.padding
        spacing: Appearance.spacing.md
        Item {
            Layout.preferredWidth: button.implicitWidth
            Layout.preferredHeight: button.implicitHeight
        }
        Column {
            id: text
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft
            StyledText {
                id: title
                weight: 500
            }
            StyledText {
                id: substring
                visible: root.substring !== ""
                size: Appearance.fontSize.sm
                animate: true
                width: 115
                elide: Text.ElideRight
            }
        }
    }

    StateLayer {
        id: rootStateLayer
        anchors.fill: parent
        z: 0
        disabled: !root.enabled
        function onClicked(event) {
            if (root.toggle)
                button.internalChecked = !button.internalChecked;
            root.textAreaClicked();
        }
        onHeld: root.textAreaHeld()
        onRightClicked: root.textAreaRightClicked()
        onMiddleClicked: root.middleClicked()
    }
    readonly property bool pressed: rootStateLayer.pressed

    IconButton {
        id: button
        z: 1
        anchors.left: parent.left
        anchors.leftMargin: root.padding
        anchors.verticalCenter: parent.verticalCenter
        padding: Appearance.spacing.md
        radius: checked ? (stateLayer.pressed ? Appearance.rounding.md : Appearance.rounding.lg) : (stateLayer.pressed ? Appearance.rounding.xl : Appearance.rounding.xxl)

        Behavior on radius {
            Anim {
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
        }

        checked: true
        iconSize: 32

        inactiveColor: Colors.palette.m3surfaceContainerHigh
        activeColor: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.8)

        onClicked: root.clicked()
        onRightClicked: root.rightClicked()
        onMiddleClicked: root.middleClicked()
        onHeld: root.held()

        StyledTooltip {
            text: root.tooltipText
        }
    }
}
