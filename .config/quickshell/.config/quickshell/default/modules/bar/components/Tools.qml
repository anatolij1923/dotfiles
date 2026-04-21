import QtQuick
import QtQuick.Layouts
import Quickshell
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

                onClicked: {
                    Quickshell.execDetached([`${Quickshell.shellDir}/scripts/colorpicker.sh`]);
                }
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
