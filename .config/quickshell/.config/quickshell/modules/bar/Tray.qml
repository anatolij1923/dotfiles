import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.services
import qs.common

Item {
    id: root

    property bool expanded: false
    property real spacing: 4

    property real firstItemWidth: (repeater.count > 0 && repeater.itemAt(0)) ? repeater.itemAt(0).implicitWidth : 0

    implicitWidth: chevronIcon.implicitWidth + spacing + (expanded ? trayRow.implicitWidth : firstItemWidth)
    implicitHeight: Math.max(chevronIcon.implicitHeight, trayRow.implicitHeight)

    Behavior on implicitWidth {
        Anim {
            duration: Appearance.animDuration.large
            easing.bezierCurve: Appearance.animCurves.emphasized
        }
    }

    MaterialSymbol {
        id: chevronIcon
        icon: root.expanded ? "chevron_right" : "chevron_left"
        color: Colors.palette.m3secondaryContainer
        visible: repeater.count > 1
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
    }

    Item {
        id: iconsClipContainer
        anchors.right: parent.right
        anchors.left: chevronIcon.right
        anchors.leftMargin: root.spacing
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        clip: true

        RowLayout {
            id: trayRow
            spacing: root.spacing

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            layoutDirection: Qt.RightToLeft

            Repeater {
                id: repeater
                model: SystemTray.items
                delegate: TrayItem {
                    Layout.minimumWidth: implicitWidth
                    onOpenMenuRequested: (handle, ix, iy, iw, ih) => menuLoader.open(handle, ix, iy, iw, ih)
                }
            }
        }
    }

    HoverHandler {
        id: hoverHandler
        onHoveredChanged: {
            if (hovered) {
                collapseTimer.stop();
                root.expanded = true;
            } else {
                collapseTimer.start();
            }
        }
    }

    Timer {
        id: collapseTimer
        interval: 400
        onTriggered: root.expanded = false
    }

    Loader {
        id: menuLoader
        active: false
        property var currentHandle: null
        property int tx
        property int ty
        property int tw
        property int th
        sourceComponent: TrayMenuWindow {
            menuHandle: menuLoader.currentHandle
            targetX: menuLoader.tx
            targetY: menuLoader.ty
            targetW: menuLoader.tw
            targetH: menuLoader.th
            onCloseRequest: menuLoader.active = false
        }
        function open(handle, ix, iy, iw, ih) {
            if (active && currentHandle === handle) {
                active = false;
                return;
            }
            currentHandle = handle;
            tx = ix;
            ty = iy;
            tw = iw;
            th = ih;
            active = true;
        }
    }

    Component.onCompleted: {
        Logger.i("TRAY", `initialized, repeater items: ${SystemTray.items}`)
        Logger.i("TRAY", `status: ${SystemTray.status}`)
    }
}
