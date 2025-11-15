import QtQuick
import qs.modules.common
import qs.services

Item {
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight
    MaterialSymbol {
        id: icon
        icon: Audio.source?.audio?.muted ? "mic_off" : "mic"
        color: Colors.palette.m3onSurface
    }
}
