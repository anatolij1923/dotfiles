pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Hyprland
import qs
import qs.services
import qs.common
import qs.widgets

Scope {
    id: root

    property var player: Players.active
    property string trackTitle: (player && player.trackTitle) || "Unknown"
    property string trackArtist: (player && player.trackArtist) || "Unknown"
    property string trackArtUrl: (player && player.trackArtUrl) || ""

    // Эти свойства обновляются таймером и делают интерфейс реактивным
    property real currentProgress: 0
    property real currentSeconds: 0

    function formatTime(seconds) {
        if (seconds === undefined || seconds === null || seconds < 0)
            return "0:00";

        let totalSeconds = Math.floor(seconds);
        let minutes = Math.floor(totalSeconds / 60);
        let secs = totalSeconds % 60;
        return minutes + ":" + (secs < 10 ? "0" : "") + secs;
    }

    Timer {
        id: progressTimer
        interval: 1000
        running: !!root.player && root.player.isPlaying
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            if (root.player) {
                // Записываем текущую позицию в нашу переменную
                root.currentSeconds = root.player.position;

                // Рассчитываем прогресс для слайдера
                if (root.player.length > 0) {
                    root.currentProgress = root.currentSeconds / root.player.length;
                } else {
                    root.currentProgress = 0;
                }
            }
        }
    }

    Loader {
        active: GlobalStates.mediaplayerOpened

        sourceComponent: StyledWindow {
            id: playerRoot
            name: "mediaplayer"
            implicitWidth: 480
            implicitHeight: 180

            anchors {
                top: true
                left: true
            }
            margins {
                left: GlobalStates.lastClickX - (playerRoot.implicitWidth / 4)
                top: Appearance.padding.normal
            }

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            exclusiveZone: 0

            function hide() {
                GlobalStates.mediaplayerOpened = false;
            }

            HyprlandFocusGrab {
                windows: [playerRoot]
                active: GlobalStates.mediaplayerOpened
                onCleared: if (!active)
                    playerRoot.hide()
            }

            ClippingRectangle {
                id: background
                anchors.fill: parent
                color: Colors.palette.m3surfaceContainer
                radius: Appearance.rounding.huge

                Image {
                    id: blurredArt
                    anchors.fill: parent
                    source: root.trackArtUrl
                    sourceSize.width: 80
                    sourceSize.height: 80
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.3
                    asynchronous: true
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
                    opacity: 0.4
                }

                ClippingRectangle {
                    id: cover
                    anchors {
                        left: parent.left
                        top: parent.top
                        bottom: parent.bottom
                        margins: Appearance.padding.large
                    }
                    width: height
                    radius: Appearance.rounding.normal
                    color: Colors.palette.m3surfaceContainerHigh

                    Image {
                        anchors.fill: parent
                        source: root.trackArtUrl
                        sourceSize.height: 80
                        sourceSize.width: 80
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
                        top: cover.top
                        left: cover.right
                        right: parent.right
                        leftMargin: Appearance.padding.large
                        rightMargin: Appearance.padding.large
                    }
                    height: titleText.height + artistText.height

                    StyledText {
                        id: titleText
                        width: parent.width
                        text: root.trackTitle
                        size: Appearance.font.size.large
                        weight: 600
                        elide: Text.ElideRight
                    }

                    StyledText {
                        id: artistText
                        anchors.top: titleText.bottom
                        width: parent.width
                        text: root.trackArtist
                        size: Appearance.font.size.small
                        opacity: 0.7
                        elide: Text.ElideRight
                    }
                }

                Item {
                    id: controls
                    anchors {
                        left: cover.right
                        right: parent.right
                        topMargin: Appearance.padding.large
                        top: textGroup.bottom
                    }

                    Row {
                        id: controlButtons
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: Appearance.padding.large

                        IconButton {
                            icon: "skip_previous"
                            inactiveColor: "transparent"
                            onClicked: root.player.previous()
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        IconButton {
                            checked: true
                            icon: root.player?.isPlaying ? "pause" : "play_arrow"
                            activeColor: Colors.mix(Colors.palette.m3onSurface, Colors.palette.m3primary, 0.8)

                            iconSize: 32
                            onClicked: root.player.togglePlaying()
                        }
                        IconButton {
                            icon: "skip_next"
                            inactiveColor: "transparent"
                            onClicked: root.player.next()
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                // Текущее время (обновляется через currentSeconds)
                StyledText {
                    anchors {
                        bottom: progressSlider.top
                        left: textGroup.left
                    }
                    opacity: 0.7
                    size: Appearance.font.size.small
                    text: root.formatTime(root.currentSeconds)
                }

                // Общее время трека
                StyledText {
                    anchors {
                        bottom: progressSlider.top
                        right: textGroup.right
                    }
                    opacity: 0.7
                    size: Appearance.font.size.small
                    text: root.formatTime(root.player?.length)
                }

                StyledSlider {
                    id: progressSlider
                    anchors {
                        bottom: cover.bottom
                        left: textGroup.left
                        right: textGroup.right
                    }

                    // Привязываем значение слайдера к нашему рассчитанному прогрессу

                    tooltipContent: root.formatTime(value * (root.player?.length || 0))

                    value: pressed ? value : root.currentProgress

                    handleHeight: 12
                    configuration: StyledSlider.Configuration.XS

                    onPressedChanged: {
                        if (pressed) {
                            // Задержка в один цикл событий, чтобы position успел обновиться
                            Qt.callLater(() => {
                                value = position;
                            });
                        } else {
                            // Когда отпустили — перематываем
                            if (root.player && root.player.length > 0) {
                                let newPos = value * root.player.length;
                                root.player.position = newPos;

                                // Сразу обновляем наши переменные, чтобы не было "отскока"
                                root.currentSeconds = newPos;
                            }
                        }
                    }
                }
            }
        }
    }
}
