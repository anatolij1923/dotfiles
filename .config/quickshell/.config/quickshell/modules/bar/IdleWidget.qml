import QtQuick
import qs.widgets
import qs.services

Item {
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    MaterialSymbol {
        id: icon
        icon: "coffee"
        color: Colors.palette.m3onSurface
        weight: 500
        size: 22
    }
}
