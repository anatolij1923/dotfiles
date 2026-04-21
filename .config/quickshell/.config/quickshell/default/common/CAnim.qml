import QtQuick
import qs.common

ColorAnimation {
    duration: Appearance.animDuration.md
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.animCurves.standard
}
