import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets
import qs

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

                onClicked: {
                    GlobalStates.screenshotOpened = true;
                }
            }
            IconButton {
                icon: "mic"
                inactiveColor: "transparent"
                iconSize: 24

                onClicked: {
                    Audio.source.audio.muted = !Audio.source.audio.muted;
                }
            }
        }
    ]
}
