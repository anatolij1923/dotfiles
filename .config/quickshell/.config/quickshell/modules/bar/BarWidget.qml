import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

Rectangle {
    id: root

    property alias spacing: layout.spacing

    implicitHeight: parent.height - 12

    implicitWidth: layout.implicitWidth + (padding * 2)

    property int padding: Appearance.padding.normal

    radius: Appearance.rounding.small
    color: Colors.palette.m3surfaceContainerLow
    Behavior on color {
        CAnim {}
    }

    default property alias content: layout.data

    RowLayout {
        id: layout
        anchors.centerIn: parent
        spacing: 4
    }
}
