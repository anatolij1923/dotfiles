pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

ClippingRectangle {
    id: root

    property var player: Players.active

    property string trackTitle: (player && player.trackTitle) || "Unknown"
    property string trackArtist: (player && player.trackArtist) || "Unknown"
    property string trackArtUrl: (player && player.trackArtUrl) || ""

    property real currentProgress: 0

    clip: true
    implicitHeight: 120
    Layout.fillWidth: true

    color: Colors.alpha(Colors.palette.m3surfaceContainer, 0.4)
    radius: Appearance.rounding.xl

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

    Item {
        id: content

        anchors {
            fill: parent
            margins: Appearance.spacing.md
        }

        Image {
            id: blurredArt
            anchors.fill: parent
            source: coverArt.source
            sourceSize.width: 100
            sourceSize.height: 100
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            opacity: 0.5
            z: -100

            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blurMax: 64
                saturation: -0.2
                blur: 1.0
            }

            Rectangle {
                anchors.fill: parent
                color: Colors.palette.m3shadow
                opacity: 0.4
            }
        }

        ClippingRectangle {
            id: cover

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            implicitWidth: height
            radius: Appearance.rounding.lg

            Layout.alignment: Qt.AlignLeft
            Layout.margins: Appearance.spacing.md

            color: Colors.palette.m3surfaceContainerHigh

            Image {
                id: coverArt
                anchors.fill: parent
                source: root.trackArtUrl

                sourceSize.width: 150
                sourceSize.height: 150
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: true

                opacity: status === Image.Ready ? 1 : 0
                Behavior on opacity {
                    Anim {}
                }
            }
        }

        ColumnLayout {
            id: trackAndArtist
            spacing: 0

            anchors {
                left: cover.right
                right: pause.left
                leftMargin: Appearance.spacing.lg
            }

            StyledText {
                id: track
                text: root.trackTitle
                size: Appearance.fontSize.lg
                elide: Text.ElideRight
                Layout.fillWidth: true
                weight: 550
            }

            StyledText {
                id: artist
                text: root.trackArtist
                size: Appearance.fontSize.sm
                // color: Colors.palette.m3outline
                opacity: 0.7
                weight: 450
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        IconButton {
            id: pause

            anchors {
                right: parent.right
                // verticalCenter: parent.verticalCenter
                bottom: next.top
                bottomMargin: Appearance.spacing.md
            }
            padding: Appearance.spacing.sm
            activeColor: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.8)
            checked: true
            icon: Players.active?.isPlaying ? "pause" : "play_arrow"
            iconSize: 28

            onClicked: {
                root.player.togglePlaying();
            }
        }

        IconButton {
            id: previous
            anchors {
                bottom: parent.bottom
                left: cover.right
                leftMargin: Appearance.spacing.md
                // bottomMargin: Appearance.spacing.xs
            }
            icon: "skip_previous"
            inactiveColor: "transparent"
            onClicked: {
                root.player.previous();
            }
        }

        StyledSlider {
            id: slider

            stopIndicatorValues: []

            handleHeight: 23

            value: root.currentProgress

            anchors {
                bottom: parent.bottom
                left: previous.right
                right: next.left
                leftMargin: Appearance.spacing.xs
                rightMargin: Appearance.spacing.xs
            }

            configuration: StyledSlider.Configuration.XS
        }

        IconButton {
            id: next
            anchors {
                bottom: parent.bottom
                right: parent.right
                // bottomMargin: Appearance.spacing.xs

            }
            icon: "skip_next"
            inactiveColor: "transparent"

            onClicked: {
                root.player.next();
            }
        }

        // IconButton {
        //     id: shuffleBtn
        //     anchors {
        //         bottom: parent.bottom
        //         right: parent.right
        //     }
        //     visible: root.player?.shuffleSupported || false // Показываем только если поддерживается
        //     icon: "shuffle"
        //     // activeColor: Colors.palette.m3primary
        //     // checked: root.player?.shuffle || false
        //     onClicked: root.player.shuffle = !root.player.shuffle
        // }

        // IconButton {
        //     id: loopBtn
        //     visible: root.player?.loopSupported || false //
        //     icon: root.player?.loopState === MprisLoopState.Track ? "repeat_one" : "repeat"
        //     iconSize: 18
        //     activeColor: Colors.palette.m3primary
        //     checked: root.player?.loopState !== MprisLoopState.None
        //     onClicked: {
        //         // Простая ротация: None -> Playlist -> Track -> None
        //         if (root.player.loopState === MprisLoopState.None)
        //             root.player.loopState = MprisLoopState.Playlist;
        //         else if (root.player.loopState === MprisLoopState.Playlist)
        //             root.player.loopState = MprisLoopState.Track;
        //         else
        //             root.player.loopState = MprisLoopState.None;
        //     }
        // }
    }
}
