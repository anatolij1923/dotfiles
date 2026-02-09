import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris
import qs
import qs.services
import qs.common
import qs.widgets

BarWidget {
    id: root

    // padding: Appearance.spacing.lg

    property var player: Players.active

    // visible: !!root.player

    StateLayer {
        anchors.fill: parent

        onClicked: {
            var globalPos = root.mapToGlobal(0, 0);
            GlobalStates.lastClickX = globalPos.x;
            GlobalStates.mediaplayerOpened = !GlobalStates.mediaplayerOpened;
        }
    }

    property string trackTitle: (player && player.trackTitle) || "Unknown"
    property string trackArtist: (player && player.trackArtist) || "Unknown"
    property string trackArtUrl: (player && player.trackArtUrl) || ""

    property real currentProgress: 0

    Timer {
        id: progressTimer
        interval: 1000
        running: root.player?.isPlaying || false
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

    rowContent: [
        RowLayout {
            id: content

            CircularProgress {
                id: circProgress
                value: root.currentProgress
                implicitSize: 32
                z: 30

                IconButton {
                    id: button
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
                text: !!root.player ? `${root.trackArtist} - ${root.trackTitle}` : "No media"
                elide: Text.ElideRight
                Layout.maximumWidth: 200
                animate: true
            }
        }
    ]
}
