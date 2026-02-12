import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.common
import qs.widgets

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight
    property bool showIcon: false

    RowLayout {
        id: row
        spacing: Appearance.spacing.sm

        anchors {
            centerIn: parent
        }

        MaterialSymbol {
            icon: "language"
            size: 24
            color: Colors.palette.m3onSurface
            Layout.alignment: Qt.AlignVCenter
            visible: root.showIcon
        }

        StyledText {
            text: WmService.isNiri ? NiriService.currentLayout : HyprlandData.currentLayoutCode
            animate: true
            weight: 400
            size: Appearance.fontSize.md
        }
    }
}
