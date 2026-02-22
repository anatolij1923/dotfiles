pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import qs.common
import qs.widgets
import qs

ClippingRectangle {
    id: root

    property var player: Players.active
    property string trackTitle: (player && player.trackTitle) || "Not Playing"
    property string trackArtist: (player && player.trackArtist) || "Select a track"
    property string trackArtUrl: (player && player.trackArtUrl) || ""

    property bool showSelector: false

    color: Colors.palette.m3surfaceContainerLowest
    radius: Appearance.rounding.xxl
    clip: true

    border.width: 1
    border.color: Colors.alpha(Colors.palette.m3outlineVariant, 0.2)

    focus: true
    Keys.onEscapePressed: showSelector === true ? showSelector = false : GlobalStates.mediaplayerOpened = false

    Item {
        id: background
        anchors.fill: parent

        StyledImage {
            id: blurredArt
            anchors.fill: parent
            source: root.trackArtUrl
            fillMode: Image.PreserveAspectCrop
            opacity: 0.35
            visible: root.trackArtUrl !== ""

            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blurMax: 100
                blur: 1.0
                saturation: 0.4
            }
        }

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Colors.alpha(Colors.palette.m3surfaceContainerLowest, 0.2)
                }
                GradientStop {
                    position: 0.5
                    color: Colors.palette.m3surfaceContainerLowest
                }
                GradientStop {
                    position: 1.0
                    color: Colors.palette.m3surfaceContainerLowest
                }
            }
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: Appearance.spacing.xl
        }
        spacing: Appearance.spacing.md

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true

            Item {
                Layout.fillWidth: true
            }

            // Rectangle {
            //     width: 32
            //     height: 4
            //     radius: Appearance.rounding.full
            //     color: Colors.alpha(Colors.palette.m3onSurface, 0.15)
            // }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 24

                RowLayout {
                    anchors.right: parent.right
                    spacing: Appearance.spacing.xs

                    Rectangle {
                        implicitWidth: sourceName.implicitWidth + 12
                        implicitHeight: 24
                        radius: Appearance.rounding.sm
                        color: root.showSelector ? Colors.alpha(Colors.palette.m3primary, 0.2) : "transparent"

                        StyledText {
                            id: sourceName
                            anchors.centerIn: parent
                            text: Players.getSourceName(root.player)
                            size: Appearance.fontSize.xs
                            weight: 700
                            color: root.showSelector ? Colors.palette.m3primary : Colors.palette.m3onSurface
                            opacity: root.showSelector ? 1.0 : 0.5
                        }

                        StateLayer {
                            anchors.fill: parent
                            onClicked: root.showSelector = !root.showSelector
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                id: mainPlayerContent
                anchors.fill: parent
                spacing: Appearance.spacing.md

                opacity: root.showSelector ? 0.1 : 1.0
                property real currentScale: root.showSelector ? 0.95 : 1.0
                scale: currentScale

                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
                Behavior on scale {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width * 0.72
                    Layout.preferredHeight: width

                    Rectangle {
                        anchors.fill: artContainer
                        anchors.topMargin: 12
                        radius: artContainer.radius
                        color: Colors.alpha(Colors.palette.m3shadow, 0.4)
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            blurEnabled: true
                            blurMax: 30
                            blur: 0.7
                        }
                    }

                    ClippingRectangle {
                        id: artContainer
                        anchors.fill: parent
                        radius: Appearance.rounding.xl
                        color: Colors.palette.m3surfaceContainer

                        StyledImage {
                            source: root.trackArtUrl || "fallback_icon"
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    StyledText {
                        text: root.trackTitle
                        size: Appearance.fontSize.xl
                        weight: 800
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }
                    StyledText {
                        text: root.trackArtist
                        size: Appearance.fontSize.sm
                        weight: 500
                        opacity: 0.8
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                        color: Colors.palette.m3primary
                    }
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    StyledSlider {
                        Layout.fillWidth: true
                        configuration: StyledSlider.Configuration.Wavy
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        StyledText {
                            text: "1:24"
                            size: Appearance.fontSize.xs
                            opacity: 0.5
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        StyledText {
                            text: "3:45"
                            size: Appearance.fontSize.xs
                            opacity: 0.5
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Appearance.spacing.sm
                    IconButton {
                        icon: "skip_previous"
                        iconSize: 34
                        horizontalPadding: Appearance.spacing.xl
                        verticalPadding: Appearance.spacing.lg
                        inactiveColor: Colors.palette.m3surfaceContainerHigh
                    }
                    IconButton {
                        id: playButton
                        icon: root.player?.isPlaying ? "pause" : "play_arrow"
                        iconSize: 34
                        horizontalPadding: Appearance.spacing.xl
                        verticalPadding: Appearance.spacing.lg
                        activeColor: Colors.palette.m3primaryContainer
                        activeOnColor: Colors.palette.m3onPrimaryContainer
                        inactiveColor: Colors.palette.m3primary
                        inactiveOnColor: Colors.palette.m3onPrimary
                        checked: true
                    }
                    IconButton {
                        icon: "skip_next"
                        iconSize: 34
                        horizontalPadding: Appearance.spacing.xl
                        verticalPadding: Appearance.spacing.lg
                        inactiveColor: Colors.palette.m3surfaceContainerHigh
                    }
                }

                Rectangle {
                    // Layout.topMargin: Appearance.spacing.xs
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: parent.width * 0.5
                    implicitHeight: 50
                    color: Colors.alpha(Colors.palette.m3surfaceContainerHigh, 0.6)
                    radius: Appearance.rounding.full
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: Appearance.spacing.sm
                        spacing: 0
                        IconButton {
                            icon: "shuffle"
                            iconSize: 20
                            Layout.fillWidth: true
                            inactiveColor: "transparent"
                            opacity: 0.7
                        }
                        IconButton {
                            icon: "repeat"
                            iconSize: 20
                            Layout.fillWidth: true
                            inactiveColor: "transparent"
                            opacity: 0.7
                        }
                    }
                }
            }

            ClippingRectangle {
                id: selectorPanel
                anchors.fill: parent
                radius: Appearance.rounding.xl
                color: Colors.alpha(Colors.palette.m3surfaceContainerHigh, 0.8)

                visible: opacity > 0
                opacity: root.showSelector ? 1.0 : 0.0
                property real currentScale: root.showSelector ? 1.0 : 0.9
                scale: currentScale

                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }
                Behavior on scale {
                    Anim {
                        duration: Appearance.animDuration.expressiveFastSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                    }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Appearance.spacing.md
                    spacing: Appearance.spacing.md

                    StyledText {
                        text: "Active Players"
                        size: Appearance.fontSize.md
                        weight: 700
                        Layout.alignment: Qt.AlignHCenter
                    }

                    ListView {
                        id: playersList
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        model: Players.list
                        spacing: Appearance.spacing.sm
                        clip: true

                        delegate: Rectangle {
                            required property var modelData

                            width: playersList.width
                            height: 56
                            radius: Appearance.rounding.lg
                            color: modelData === Players.active ? Colors.palette.m3primary : Colors.alpha(Colors.palette.m3surface, 0.3)

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: Appearance.spacing.md
                                spacing: Appearance.spacing.md

                                MaterialSymbol {
                                    icon: "music_note"
                                    size: 24
                                    color: parent.parent.modelData === Players.active ? Colors.palette.m3onPrimary : Colors.palette.m3onSurface
                                }

                                ColumnLayout {
                                    spacing: 0
                                    Layout.fillWidth: true
                                    StyledText {
                                        text: parent.parent.parent.modelData.identity
                                        size: Appearance.fontSize.sm
                                        weight: 700
                                        color: parent.parent.parent.modelData === Players.active ? Colors.palette.m3onPrimary : Colors.palette.m3onSurface
                                    }
                                    StyledText {
                                        text: parent.parent.parent.modelData.trackTitle || "Idle"
                                        size: Appearance.fontSize.xs
                                        opacity: 0.7
                                        elide: Text.ElideRight
                                        Layout.fillWidth: true
                                        color: parent.parent.parent.modelData === Players.active ? Colors.palette.m3onPrimary : Colors.palette.m3onSurface
                                    }
                                }
                            }

                            StateLayer {
                                anchors.fill: parent
                                onClicked: {
                                    Players.manualPlayer = parent.modelData;
                                    root.showSelector = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
