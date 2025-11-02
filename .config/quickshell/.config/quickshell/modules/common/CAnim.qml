import QtQuick
import qs.services

ColorAnimation {
    duration: Appearance.animDuration.normal
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.animCurves.standart
}
