import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import qs.modules.settings
import qs.modules.settings.components
import qs.common
import qs.widgets
import qs.services
import qs.config

ContentPage {
    title: "Appearance"

    ContentItem {
        title: "Background"

        RowLayout {

            ClippingRectangle {
                Layout.preferredHeight: 220
                Layout.preferredWidth: 330
                clip: true
                color: "transparent"
                radius: Appearance.rounding.normal

                Image {
                    anchors.fill: parent
                    source: Config.background.wallpaperPath
                    fillMode: Image.PreserveAspectCrop
                    sourceSize.width: 330
                    asynchronous: true
                    cache: true
                }
            }

            ColumnLayout {
                TextIconButton {
                    icon: "wallpaper"
                    text: "Random: Wallhaven"
                    padding: Appearance.padding.normal
                    inactiveColor: Colors.palette.m3surfaceContainerHigh

                    checked: RandomWallpaper.isLoading

                    onClicked: {
                        RandomWallpaper.fetchWallhaven();
                    }

                    StyledTooltip {
                        text: "Download random wallpaper from Wallhavem.cc"
                    }
                }

                TextIconButton {
                    icon: "wallpaper"
                    text: "Random: Konachan"
                    padding: Appearance.padding.normal
                    inactiveColor: Colors.palette.m3surfaceContainerHigh

                    checked: RandomWallpaper.isLoading

                    onClicked: {
                        RandomWallpaper.fetchKonachan();
                    }

                    StyledTooltip {
                        text: "ass tits pussies"
                    }
                }
            }
        }

        TextFieldRow {
            label: "Wallpaper"
            value: Config.background.wallpaperPath
            onValueChanged: Config.background.wallpaperPath = value
        }

        SwitchRow {
            label: "Parallax effect"
            value: Config.background.parallax.enabled
            onToggled: Config.background.parallax.enabled = value
        }

        SliderRow {
            label: "Parallax scale"
            value: Config.background.parallax.wallpaperScale
            from: 1.0
            to: 2.0
            step: 1
            suffix: "x"
            onValueChanged: Config.background.parallax.wallpaperScale = value
        }

        SwitchRow {
            label: "Dim effect"
            value: Config.background.dim.enabled
            onToggled: Config.background.dim.enabled = value
        }

        SliderRow {
            label: "Dim transparency"
            value: Config.background.dim.opacity
            from: 0
            to: 1
            step: 100
            suffix: "%"
            onValueChanged: Config.background.dim.opacity = value
        }
    }

    ContentItem {
        title: "Theme"

        SwitchRow {
            label: "Dark mode"
            value: Config.appearance.darkMode
            onToggled: Config.appearance.darkMode = value
        }
    }

    ContentItem {
        title: "Transparency"

        SwitchRow {
            label: "Enable"
            value: Config.appearance.transparency.enabled
            onToggled: Config.appearance.transparency.enabled = value
        }
        SliderRow {
            label: "Alpha"
            value: Config.appearance.transparency.alpha
            from: 0.25
            to: 1
            step: 100
            suffix: "%"
            onValueChanged: Config.appearance.transparency.alpha = value
        }
    }
}
