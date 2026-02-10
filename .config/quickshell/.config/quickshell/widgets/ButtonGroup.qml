import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.common
import qs.widgets
import qs.services

ClippingRectangle {
    id: rootLayout

    color: "transparent"
    default property alias data: rowLayout.data
    clip: true
    radius: Appearance.rounding.full

    implicitWidth: rowLayout.implicitWidth 
    implicitHeight: rowLayout.implicitHeight

    children: RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: 2
    }
}
