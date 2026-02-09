import QtQuick
import QtQuick.Shapes
import qs.services
import QtQuick.Controls
import qs.common
import qs.widgets

// From https://github.com/caelestia-dots/shell with modifiacations
// License: GPLv3

Switch {
    id: root

    property int cLayer: 1

    implicitWidth: implicitIndicatorWidth
    implicitHeight: implicitIndicatorHeight

    indicator: Rectangle {
        radius: Appearance.rounding.full
        color: root.checked ? Colors.palette.m3primary : Colors.palette.m3surfaceContainerHighest

        implicitWidth: implicitHeight * 1.7
        implicitHeight: Appearance.fontSize.xl + Appearance.spacing.xs * 2

        border {
            width: root.checked ? 0 : 2
            color: Colors.palette.m3outline
        }

        Rectangle {
            readonly property real nonAnimWidth: root.pressed ? implicitHeight * 1.3 : implicitHeight

            radius: Appearance.rounding.full
            color: root.checked ? Colors.palette.m3onPrimary : Colors.palette.m3outline

            x: root.checked ? parent.implicitWidth - nonAnimWidth - Appearance.spacing.sm / 2 : Appearance.spacing.sm / 2
            implicitWidth: nonAnimWidth
            implicitHeight: parent.implicitHeight - Appearance.spacing.sm
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill: parent
                radius: parent.radius

                color: root.checked ? Colors.palette.m3primary : Colors.palette.m3onSurface
                opacity: root.pressed ? 0.1 : root.hovered ? 0.08 : 0

                Behavior on opacity {
                    Anim {}
                }
            }

            Shape {
                id: icon

                property point start1: {
                    if (root.pressed)
                        return Qt.point(width * 0.2, height / 2);
                    if (root.checked)
                        return Qt.point(width * 0.15, height / 2);
                    return Qt.point(width * 0.15, height * 0.15);
                }
                property point end1: {
                    if (root.pressed) {
                        if (root.checked)
                            return Qt.point(width * 0.4, height / 2);
                        return Qt.point(width * 0.8, height / 2);
                    }
                    if (root.checked)
                        return Qt.point(width * 0.4, height * 0.7);
                    return Qt.point(width * 0.85, height * 0.85);
                }
                property point start2: {
                    if (root.pressed) {
                        if (root.checked)
                            return Qt.point(width * 0.4, height / 2);
                        return Qt.point(width * 0.2, height / 2);
                    }
                    if (root.checked)
                        return Qt.point(width * 0.4, height * 0.7);
                    return Qt.point(width * 0.15, height * 0.85);
                }
                property point end2: {
                    if (root.pressed)
                        return Qt.point(width * 0.8, height / 2);
                    if (root.checked)
                        return Qt.point(width * 0.85, height * 0.2);
                    return Qt.point(width * 0.85, height * 0.15);
                }

                anchors.centerIn: parent
                width: height
                height: parent.implicitHeight - Appearance.spacing.sm * 2
                preferredRendererType: Shape.CurveRenderer
                asynchronous: true

                ShapePath {
                    strokeWidth: Appearance.fontSize.md * 0.15
                    strokeColor: root.checked ? Colors.palette.m3primary : Colors.palette.m3surfaceContainerHighest
                    fillColor: "transparent"
                    capStyle: Appearance.rounding.sm === 0 ? ShapePath.SquareCap : ShapePath.RoundCap

                    startX: icon.start1.x
                    startY: icon.start1.y

                    PathLine {
                        x: icon.end1.x
                        y: icon.end1.y
                    }
                    PathMove {
                        x: icon.start2.x
                        y: icon.start2.y
                    }
                    PathLine {
                        x: icon.end2.x
                        y: icon.end2.y
                    }

                    Behavior on strokeColor {
                        CAnim {}
                    }
                }

                Behavior on start1 {
                    PropAnim {}
                }
                Behavior on end1 {
                    PropAnim {}
                }
                Behavior on start2 {
                    PropAnim {}
                }
                Behavior on end2 {
                    PropAnim {}
                }
            }

            Behavior on x {
                Anim {}
            }

            Behavior on implicitWidth {
                Anim {}
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: false
    }

    component PropAnim: PropertyAnimation {
        duration: Appearance.animDuration.md
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animCurves.standard
    }
}
