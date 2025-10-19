import QtQuick
import qs.services

NumberAnimation {
    duration: Appearance.animDuration.normal
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Appearance.animCurves.standart
}
