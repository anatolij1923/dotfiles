import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

BarWidget {
    rowContent: [
        RowLayout {
            IconButton {
                icon: "colorize"
                inactiveColor: "transparent"
                iconSize: 24
            }
            IconButton {
                icon: "screenshot_region"
                inactiveColor: "transparent"
                iconSize: 24
            }
        }
    ]
}
