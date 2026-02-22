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

ClippingRectangle {
    id: root

    property var player: Players.active
    property string trackTitle: (player && player.trackTitle) || "Not Playing"
    property string trackArtist: (player && player.trackArtist) || "Select a track"
    property string trackArtUrl: (player && player.trackArtUrl) || ""

    color: Colors.palette.m3surfaceContainerLowest
    radius: Appearance.rounding.xxl
    clip: true

    border.width: 1
    border.color: Colors.alpha(Colors.palette.m3outlineVariant, 0.2)

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
                GradientStop { position: 0.0; color: Colors.alpha(Colors.palette.m3surfaceContainerLowest, 0.2) }
                GradientStop { position: 0.5; color: Colors.palette.m3surfaceContainerLowest }
                GradientStop { position: 1.0; color: Colors.palette.m3surfaceContainerLowest }
            }
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: Appearance.spacing.xl
        }
        spacing: Appearance.spacing.md

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 32
            height: 4
            radius: Appearance.rounding.full
            color: Colors.alpha(Colors.palette.m3onSurface, 0.15)
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

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.width: 1
                    border.color: Colors.alpha("#ffffff", 0.1) 
                    radius: parent.radius
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
                color: Colors.palette.m3onSurface
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
                StyledText { text: "1:24"; size: Appearance.fontSize.xs; opacity: 0.5 }
                Item { Layout.fillWidth: true }
                StyledText { text: "3:45"; size: Appearance.fontSize.xs; opacity: 0.5 }
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
                inactiveOnColor: Colors.palette.m3onSurface
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
                inactiveOnColor: Colors.palette.m3onSurface
            }
        }

        Rectangle {
            Layout.topMargin: Appearance.spacing.xs
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: parent.width * 0.5
            implicitHeight: 44 

            color: Colors.alpha(Colors.palette.m3surfaceContainerHigh, 0.6)
            radius: Appearance.rounding.full
            border.width: 1
            border.color: Colors.alpha(Colors.palette.m3outlineVariant, 0.1)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Appearance.spacing.sm
                anchors.rightMargin: Appearance.spacing.sm
                spacing: 0

                IconButton {
                    icon: "shuffle"
                    iconSize: 20
                    Layout.fillWidth: true
                    inactiveColor: "transparent"
                    inactiveOnColor: Colors.palette.m3onSurfaceVariant
                    opacity: 0.7
                }

                IconButton {
                    icon: "repeat"
                    iconSize: 20
                    Layout.fillWidth: true
                    inactiveColor: "transparent"
                    inactiveOnColor: Colors.palette.m3onSurfaceVariant
                    opacity: 0.7
                }
            }
        }
    }
}
