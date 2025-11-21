import QtQuick
import qs.modules.common
import qs.services

Item {
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    MaterialSymbol {
        id: icon
        icon: "mic_off"
        color: Colors.palette.m3onSurface
    }
}
