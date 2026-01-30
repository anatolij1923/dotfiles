import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

BarWidget {
    RowLayout {
        IconButton {
            icon: "colorize"
            inactiveColor: "transparent"
            iconSize: 22
        }
        IconButton {
            icon: "screenshot_region"
            inactiveColor: "transparent"
            iconSize: 22
        }
    }
}
