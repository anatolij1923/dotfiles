import Quickshell
import QtQuick
import qs
import qs.modules.common
import qs.services

Item {
    id: root
    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    MaterialSymbol {
        id: icon
        icon: Network.icon
        color: Colors.palette.m3onSurface
    }
}
