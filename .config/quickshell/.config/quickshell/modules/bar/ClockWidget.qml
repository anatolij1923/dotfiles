import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.widgets
import qs.common
import qs.services
import qs.config

BarWidget {
    id: root
    property string timeFormat: Config.time.format
    property string dateFormat: Config.time.dateFormat

    padding: Appearance.padding.huge

    rowContent: [
        RowLayout {
            id: content

            StyledText {
                id: timeSection
                text: Time.format(`${root.timeFormat} • ${root.dateFormat}`)
            }
        }
    ]
}
