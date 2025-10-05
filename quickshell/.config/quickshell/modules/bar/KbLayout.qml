import Quickshell
import QtQuick
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        spacing: 8
        Layout.alignment: Qt.AlignVCenter  // выравнивание по вертикали

        MaterialSymbol {
            icon: "language"
            font.pixelSize: 24
            color: Colors.on_surface
            Layout.alignment: Qt.AlignVCenter
        }

        StyledText {
            text: HyprlandXkb.currentLayoutCode
        }
    }
}
