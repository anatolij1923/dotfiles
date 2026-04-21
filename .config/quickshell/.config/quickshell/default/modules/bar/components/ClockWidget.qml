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

    padding: Appearance.spacing.xl

    StateLayer {
        anchors.fill: parent
        onClicked: {
            GlobalStates.dashboardOpened = !GlobalStates.dashboardOpened;
        }
    }

    rowContent: [
        RowLayout {
            id: content

            StyledText {
                text: Time.format(`${root.timeFormat}`)
                weight: 450
            }
            StyledText {
                text: "•"
            }
            StyledText {
                text: Time.format(`${root.dateFormat}`)
            }
        }
    ]
}
