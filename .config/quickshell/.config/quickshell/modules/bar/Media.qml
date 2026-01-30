import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs.services
import qs.common
import qs.widgets

Item {
    id: root

    property var player: Players.active
    visible: !!root.player

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
                    if (root.player) {
                        if (root.player.isPlaying) {
                            root.player.pause();
                        } else {
                            root.player.play();
                        }
                    }
                }
            }
        }

        StyledText {
            text: `${root.trackArtist} - ${root.trackTitle}`
            elide: Text.ElideRight
            Layout.maximumWidth: 300
            opacity: 0.8
            weight: 500
        }
    }
}
