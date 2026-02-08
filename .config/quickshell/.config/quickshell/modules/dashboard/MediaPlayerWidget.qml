pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.common
import qs.widgets

Item {
    id: root

    property bool expanded
    property var player: Players.active
    property string trackTitle: (player && player.trackTitle) || "Unknown"
    property string trackArtist: (player && player.trackArtist) || "Unknown"
    property string trackArtUrl: (player && player.trackArtUrl) || ""

    property real currentProgress: 0
    property real currentSeconds: 0

    clip: true
    state: expanded ? "expanded" : "collapsed"

    function formatTime(seconds) {
        if (seconds === undefined || seconds === null || seconds < 0) {
            return "0:00";
        }
        let totalSeconds = Math.floor(seconds);
        let minutes = Math.floor(totalSeconds / 60);
        let secs = totalSeconds % 60;
        return minutes + ":" + (secs < 10 ? "0" : "") + secs;
    }

    Timer {
        id: progressTimer
        interval: 500
        running: !!root.player && root.player.isPlaying
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (root.player) {
                root.currentSeconds = root.player.position;

                if (root.player.length > 0) {
                    root.currentProgress = root.currentSeconds / root.player.length;
                } else {
                    root.currentProgress = 0;
                }
            }
        }
    }

    ClippingRectangle {
        id: background
        anchors.fill: parent
        color: "transparent"
        radius: Appearance.rounding.small
        clip: true

        Image {
            id: blurredArt
            anchors.fill: parent
            source: root.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            opacity: 0.3
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blurMax: 64
                saturation: -0.2
                blur: 1.0
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Colors.palette.m3shadow
            visible: blurredArt.status === Image.StatusReady
            opacity: 0
        }

        ClippingRectangle {
            id: cover
            radius: Appearance.rounding.normal
            color: Colors.palette.m3surfaceContainerHigh

            height: root.expanded ? (parent.height - Appearance.padding.large * 2) : (parent.width - Appearance.padding.normal * 2)
            width: height

            anchors {
                left: parent.left
                top: parent.top
                leftMargin: root.expanded ? Appearance.padding.large : Appearance.padding.normal
                topMargin: root.expanded ? Appearance.padding.large : Appearance.padding.normal
            }

            Image {
                anchors.fill: parent
                source: root.trackArtUrl
                fillMode: Image.PreserveAspectCrop
                opacity: status === Image.Ready ? 1 : 0
                Behavior on opacity {
                    Anim {}
                }
            }
        }

        Item {
            id: textGroup
            anchors {
                left: root.expanded ? cover.right : parent.left
                right: parent.right
                top: root.expanded ? cover.top : cover.bottom

                leftMargin: root.expanded ? Appearance.padding.large : Appearance.padding.normal
                rightMargin: root.expanded ? Appearance.padding.large : Appearance.padding.normal
                topMargin: root.expanded ? 0 : Appearance.padding.small
            }
            height: titleText.height + artistText.height

            StyledText {
                id: titleText
                width: parent.width
                text: root.trackTitle
                size: root.expanded ? Appearance.font.size.large : Appearance.font.size.normal
                weight: 600
                elide: Text.ElideRight
                horizontalAlignment: root.expanded ? Text.AlignLeft : Text.AlignHCenter
            }

            StyledText {
                id: artistText
                anchors.top: titleText.bottom
                width: parent.width
                text: root.trackArtist
                size: root.expanded ? Appearance.font.size.small : Appearance.font.size.tiny
                opacity: 0.7
                elide: Text.ElideRight
                horizontalAlignment: root.expanded ? Text.AlignLeft : Text.AlignHCenter
            }
        }

        Item {
            id: timeRowCenter
            visible: !root.expanded
            opacity: root.expanded ? 0 : 1
            height: 20
            anchors {
                top: textGroup.bottom
                left: parent.left
                right: parent.right
                topMargin: Appearance.padding.smaller
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 6
                StyledText {
                    text: root.formatTime(root.currentSeconds)
                    size: Appearance.font.size.small
                }
                StyledText {
                    text: "/"
                    size: Appearance.font.size.small
                    opacity: 0.5
                }
                StyledText {
                    text: root.formatTime(root.player?.length)
                    size: Appearance.font.size.small
                    opacity: 0.7
                }
            }
        }

        Item {
            id: controls
            anchors {
                left: root.expanded ? cover.right : parent.left
                right: parent.right
                top: root.expanded ? textGroup.bottom : timeRowCenter.bottom
                topMargin: root.expanded ? Appearance.padding.large : 0
            }
            height: 48

            Row {
                id: controlButtons
                anchors.centerIn: parent
                spacing: root.expanded ? Appearance.padding.large : Appearance.padding.normal

                IconButton {
                    icon: "skip_previous"
                    inactiveColor: "transparent"
                    onClicked: root.player?.previous()
                    anchors.verticalCenter: parent.verticalCenter
                }
                IconButton {
                    checked: true
                    icon: root.player?.isPlaying ? "pause" : "play_arrow"
                    activeColor: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.8)
                    iconSize: root.expanded ? 32 : 28
                    onClicked: root.player?.togglePlaying()
                    anchors.verticalCenter: parent.verticalCenter
                }
                IconButton {
                    icon: "skip_next"
                    inactiveColor: "transparent"
                    onClicked: root.player?.next()
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        StyledSlider {
            id: progressSlider
            anchors {
                bottom: cover.bottom
                left: textGroup.left
                right: textGroup.right
            }
            visible: root.expanded
            opacity: root.expanded ? 1 : 0
            value: pressed ? value : root.currentProgress
            handleHeight: 12
            configuration: StyledSlider.Configuration.XS

            tooltipContent: root.formatTime(value * (root.player?.length || 0))

            onPressedChanged: {
                if (pressed) {
                    Qt.callLater(() => {
                        value = position;
                    });
                } else {
                    if (root.player && root.player.length > 0) {
                        let newPos = value * root.player.length;
                        root.player.position = newPos;
                        root.currentSeconds = newPos;
                    }
                }
            }
        }
        StyledText {
            id: timeCurrent
            anchors {
                bottom: progressSlider.top
                left: textGroup.left
            }
            size: Appearance.font.size.small
            text: root.formatTime(root.currentSeconds)
            visible: root.expanded
            opacity: root.expanded ? 0.7 : 0
        }
        StyledText {
            id: timeTotal
            anchors {
                bottom: progressSlider.top
                right: textGroup.right
            }
            size: Appearance.font.size.small
            text: root.formatTime(root.player?.length)
            visible: root.expanded
            opacity: root.expanded ? 0.7 : 0
        }
    }

    states: [
        State {
            name: "collapsed"
            when: !root.expanded
        },
        State {
            name: "expanded"
            when: root.expanded
        }
    ]

    transitions: Transition {
        ParallelAnimation {
            AnchorAnimation {
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.type: Easing.BezierSpline
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
            Anim {
                properties: "width,height,opacity,anchors.leftMargin,anchors.rightMargin,anchors.topMargin,anchors.margins"
                duration: Appearance.animDuration.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
            }
        }
    }
}
