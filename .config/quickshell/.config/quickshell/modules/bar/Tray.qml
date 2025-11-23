import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common

MouseArea {
    id: root
    implicitWidth: trayWidth
    implicitHeight: tray.implicitHeight

    property bool isSingleItem: repeater.count == 1
    property int singleItemSize: {
        if (repeater.count > 0 && repeater.itemAt(0)) {
            return repeater.itemAt(0).implicitWidth;
        }
    }

    property int trayWidth: (root.containsMouse ? tray.implicitWidth : singleItemSize + dot.implicitWidth)

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.expressiveFastSpatial
            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
        }
    }

    hoverEnabled: true

    clip: true

    RowLayout {
        id: tray
        spacing: 2

        StyledText {
            id: dot
            text: "•"
            weight: 900
            size: 20
            color: Colors.palette.m3outline
        }

        Repeater {
            id: repeater

            model: SystemTray.items
            delegate: TrayItem {}
        }
    }
}
