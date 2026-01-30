import QtQuick
import qs.common

ColorAnimation {
    duration: Appearance.animDuration.normal
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.animCurves.standard
}
