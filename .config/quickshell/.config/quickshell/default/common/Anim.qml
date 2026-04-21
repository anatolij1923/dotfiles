import QtQuick
import qs.common

NumberAnimation {
    duration: Appearance.animDuration.md
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.animCurves.standard
}
