import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs
import qs.modules.common
import qs.services
import qs.config

BarWidget {
    id: root
    property string timeFormat: Config.time.format
    property string dateFormat: Config.time.dateFormat

    padding: Appearance.padding.huge
    // implicitWidth: content.implicitWidth
    // implicitHeight: content.implicitHeight

    RowLayout {
        id: content
        // anchors.fill: parent

        StyledText {
            id: timeSection
            text: Time.format(`${timeFormat} • ${dateFormat}`)
        }
    }
}
