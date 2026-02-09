pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    visible: false
    property string title: ""
    property alias contentWidth: card.implicitWidth
    property alias contentHeight: card.implicitHeight
    property real contentWidthRatio: 0.8
    property int maxContentHeight: 50

    signal closed

    focus: true
    Keys.onEscapePressed: close()

    property bool _animShownValue: false

    z: 1000
    enabled: visible

    SequentialAnimation {
        id: closeSeq
        PauseAnimation {
            duration: Appearance.animDuration.expressiveFastSpatial
        }
        ScriptAction {
            script: {
                root.visible = false;
                root.closed();
            }
        }
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: Colors.alpha(Colors.palette.m3scrim, 0.4)
        opacity: root._animShownValue ? 1 : 0

        Behavior on opacity {
            Anim {
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onPressed: mouse => {
                mouse.accepted = true;
                root.close();
            }
        }
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: root.parent ? root.parent.width * contentWidthRatio : 300
        height: contentLayout.implicitHeight + Appearance.spacing.lg * 2
        color: Colors.palette.m3surfaceContainer
        radius: Appearance.rounding.xl
        transformOrigin: Item.Center

        scale: root._animShownValue ? 1 : 0.95
        opacity: root._animShownValue ? 1 : 0

        Behavior on scale {
            Anim {
                duration: Appearance.animDuration.expressiveFastSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animCurves.emphasizedDecel
            }
        }
        Behavior on opacity {
            Anim {
                duration: Appearance.animDuration.expressiveFastSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animCurves.expressiveEffects
            }
        }

        implicitWidth: contentLayout.implicitWidth + Appearance.spacing.lg * 2
        implicitHeight: contentLayout.implicitHeight + Appearance.spacing.lg * 2

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            onPressed: mouse => mouse.accepted = true
        }

        ColumnLayout {
            id: contentLayout
            anchors {
                fill: parent
                margins: Appearance.spacing.lg
            }
            spacing: 0

            StyledText {
                text: root.title
                visible: root.title !== ""
                size: Appearance.font.size.xlarge
                Layout.fillWidth: true
                Layout.bottomMargin: Appearance.spacing.sm
            }
        }
    }

    default property alias contentData: contentLayout.data

    function open() {
        root.visible = true;
        root._animShownValue = false;
        Qt.callLater(() => {
            root._animShownValue = true;
            root.forceActiveFocus();
        });
    }

    function close() {
        root._animShownValue = false;
        closeSeq.restart();
    }
}
