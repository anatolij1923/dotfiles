import QtQuick
import qs.widgets
import qs.services
import qs.common

Rectangle {
    implicitWidth: icon.implicitWidth + Appearance.spacing.sm * 2
    implicitHeight: icon.implicitHeight

    radius: Appearance.rounding.full
    color: Colors.palette.m3primary

    MaterialSymbol {
        id: icon
        anchors.centerIn: parent
        icon: "timer"
        color: Colors.palette.m3surface
    }
}
