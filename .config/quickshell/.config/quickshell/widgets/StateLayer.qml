import qs.services
import qs.common
import qs
import QtQuick
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects

// From https://github.com/caelestia-dots/shell with modifiacations
// License: GPLv3

MouseArea {
    id: root

    property bool disabled
    property color color: Colors.palette.m3onSurface
    property real radius: parent?.radius ?? 0
    property alias rect: hoverLayer

    signal rightClicked
    signal middleClicked
    signal held

    function onClicked(): void {
    }

    anchors.fill: parent

    enabled: !disabled
    cursorShape: disabled ? undefined : Qt.PointingHandCursor
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    Timer {
        id: holdTimer
        interval: 300
        onTriggered: {
            root.held();
        }
    }

    onPressed: event => {
        if (disabled)
            return;

        if (event.button === Qt.LeftButton) {
            holdTimer.start();
            rippleExitAnim.stop();

            rippleEnterAnim.startX = event.x;
            rippleEnterAnim.startY = event.y;

            const dist = (ox, oy) => ox * ox + oy * oy;
            rippleEnterAnim.targetRadius = Math.sqrt(Math.max(dist(event.x, event.y), dist(event.x, height - event.y), dist(width - event.x, event.y), dist(width - event.x, height - event.y))) * 3;

            rippleEnterAnim.restart();
        } else if (event.button === Qt.RightButton) {
            rightClicked();
        } else if (event.button === Qt.MiddleButton) {
            middleClicked();
        }
    }

    onReleased: event => {
        if (event.button === Qt.LeftButton) {
            holdTimer.stop();
            rippleExitAnim.restart();
        }
    }

    onCanceled: {
        rippleExitAnim.restart();
    }

    onClicked: event => {
        if (!disabled && event.button === Qt.LeftButton) {
            if (holdTimer.running) {
                holdTimer.stop();
                onClicked(event);
            }
        }
    }

    SequentialAnimation {
        id: rippleEnterAnim

        property real startX
        property real startY
        property real targetRadius

        ScriptAction {
            script: {
                ripple.x = rippleEnterAnim.startX;
                ripple.y = rippleEnterAnim.startY;
                ripple.opacity = 0.12;
                ripple.implicitWidth = 0;
                ripple.implicitHeight = 0;
            }
        }

        Anim {
            target: ripple
            properties: "implicitWidth,implicitHeight"
            to: rippleEnterAnim.targetRadius * 2
            duration: 1400
            easing.bezierCurve: Appearance.animCurves.standardDecel
        }
    }

    Anim {
        id: rippleExitAnim
        target: ripple
        property: "opacity"
        to: 0
    }

    ClippingRectangle {
        id: hoverLayer

        anchors.fill: parent

        color: Qt.alpha(root.color, root.disabled ? 0 : root.containsMouse ? 0.08 : 0)
        radius: root.radius

        Item {
            id: ripple

            property real implicitWidth: 0
            property real implicitHeight: 0
            width: implicitWidth
            height: implicitHeight

            opacity: 0
            visible: opacity > 0

            RadialGradient {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: root.color
                    }
                    GradientStop {
                        position: 0.25
                        color: root.color
                    }
                    GradientStop {
                        position: 0.3
                        color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0)
                    }
                }
            }

            transform: Translate {
                x: -ripple.width / 2
                y: -ripple.height / 2
            }
        }
    }
}
