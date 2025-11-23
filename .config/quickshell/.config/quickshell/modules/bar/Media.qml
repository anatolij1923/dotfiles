import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs.services
import qs.modules.common

Item {
    id: root
    implicitHeight: content.implicitHeight
    implicitWidth: 300

    RowLayout {
        id: content

        IconButton {
            icon: Players.active?.isPlaying ? "pause" : "play_arrow"

            onClicked: {
                if (Players.active?.isPlaying) {
                    Players.active.pause();
                }
                Players.active.play();
            }
        }

        StyledText {
            text: Players.active?.trackArtist
        }

        StyledText {
            text: Players.active?.trackTitle
        }
    }
}
