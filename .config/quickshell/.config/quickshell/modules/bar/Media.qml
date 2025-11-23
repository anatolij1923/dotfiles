import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs.services
import qs.modules.common

Item {
    id: root

    property var player: Players.active

    property string trackTitle: player?.trackTitle
    property string trackArtist: player?.trackArtist

    property real currentProgress: 0

    implicitHeight: content.implicitHeight
    implicitWidth: 300

    Timer {
        id: progressTimer
        interval: 1000
        running: root.player?.isPlaying
        repeat: true

        onTriggered: {
            if (root.player && root.player.length > 0) {
                root.currentProgress = root.player.position / root.player.length;
            } else {
                root.currentProgress = 0;
            }
        }
    }
    Connections {
        target: root.player

        function onPositionChanged() {
            progressTimer.triggered();
        }
    }

    RowLayout {
        id: content

        CircularProgress {
            id: circProgress
            value: root.currentProgress
            implicitSize: 32

            IconButton {
                icon: Players.active?.isPlaying ? "pause" : "play_arrow"
                iconSize: 22
                anchors.fill: parent
                color: "transparent"
                onClicked: {
                    if (Players.active?.isPlaying) {
                        Players.active.pause();
                    }
                    Players.active.play();
                }
            }
        }

        StyledText {
            text: `${root.trackArtist} - ${root.trackTitle}`
            opacity: 0.8
            weight: 500
        }
    }
}
