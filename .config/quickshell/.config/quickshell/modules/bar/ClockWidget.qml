import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs
import qs.widgets
import qs.common
import qs.services
import qs.config

BarWidget {
    id: root
    property string timeFormat: Config.time.format
    property string dateFormat: Config.time.dateFormat

    padding: Appearance.padding.huge

    StateLayer {
        anchors.fill: parent
        onClicked: {
            GlobalStates.dashboardOpened = !GlobalStates.dashboardOpened
        }
    }

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
