pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.config
import qs.modules.lock
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root
    color: Colors.palette.m3surface
    implicitHeight: 64
    implicitWidth: content.implicitWidth + Appearance.spacing.lg * 2
    radius: Appearance.rounding.full

    Rectangle {
        id: content
        anchors {
            fill: parent
            margins: Appearance.spacing.sm
        }

        implicitWidth: contentRow.implicitWidth

        color: Colors.palette.m3surfaceContainer
        radius: Appearance.rounding.full

        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            MaterialSymbol {
                icon: "keyboard"
                color: Colors.palette.m3onSurface
            }

            StyledText {
                text: HyprlandData.currentLayoutCode
            }
        }
    }
}
