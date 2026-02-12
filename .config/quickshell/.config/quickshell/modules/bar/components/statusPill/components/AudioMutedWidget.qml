import QtQuick
import qs.widgets
import qs.services

Item {
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    MaterialSymbol {
        id: icon
        icon: "volume_off"
        color: Colors.palette.m3onSurface
        size: 22
    }
}
