import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

Item {
    id: root
    implicitWidth: row.implicitWidth + 8
    implicitHeight: row.implicitHeight
    property bool showIcon: false

    RowLayout {
        id: row
        spacing: 8
        Layout.alignment: Qt.AlignVCenter

        MaterialSymbol {
            icon: "language"
            font.pixelSize: 24
            color: Colors.on_surface
            Layout.alignment: Qt.AlignVCenter
            visible: root.showIcon
        }

        StyledText {
            text: HyprlandXkb.currentLayoutCode
            animate: true
            weight: 400
        }
    }
}
