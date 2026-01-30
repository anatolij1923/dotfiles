import Quickshell
import QtQuick
import qs
import qs.common
import qs.widgets
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
