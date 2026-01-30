import QtQuick
import QtQuick.Effects
import qs.common
import qs.services

RectangularShadow {
    id: root
    required property var target
    anchors.fill: target
    radius: target.radius
    color: Colors.palette.m3shadow
    spread: 1
    blur: 20
    offset: Qt.vector2d(0.0, 1.0)
}
