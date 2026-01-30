import QtQuick
import qs.common

NumberAnimation {
    duration: Appearance.animDuration.normal
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.animCurves.standard
}
