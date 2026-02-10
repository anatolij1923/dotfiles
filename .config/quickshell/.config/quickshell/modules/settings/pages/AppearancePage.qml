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
    title: Translation.tr("settings.appearance.title")

    ContentItem {
        title: Translation.tr("settings.appearance.background")

        ColumnLayout {

            ClippingRectangle {
                Layout.preferredHeight: 220
                Layout.preferredWidth: 330
                clip: true
                color: "transparent"
                radius: Appearance.rounding.lg

                Image {
                    anchors.fill: parent
                    source: Config.background.wallpaperPath
                    fillMode: Image.PreserveAspectCrop
                    sourceSize.width: 330
                    asynchronous: true
                    cache: true
                }
            }

            RowLayout {
                ButtonGroup {

                    TextIconButton {
                        icon: "wallpaper"
                        text: Translation.tr("settings.appearance.random_wallhaven")
                        padding: Appearance.spacing.md
                        inactiveColor: Colors.palette.m3surfaceContainerHigh

                        radius: Appearance.rounding.sm
                        checked: RandomWallpaper.isLoading

                        onClicked: {
                            RandomWallpaper.fetchWallhaven();
                        }

                        StyledTooltip {
                            text: Translation.tr("settings.appearance.random_wallhaven_tooltip")
                        }
                    }
                    TextIconButton {
                        icon: "wallpaper"
                        text: Translation.tr("settings.appearance.random_konachan")
                        padding: Appearance.spacing.md

                        inactiveColor: Colors.palette.m3surfaceContainerHigh

                        radius: Appearance.rounding.sm
                        checked: RandomWallpaper.isLoading

                        onClicked: {
                            RandomWallpaper.fetchKonachan();
                        }

                        StyledTooltip {
                            text: Translation.tr("settings.appearance.random_konachan_tooltip")
                        }
                    }
                }
            }
        }

        TextFieldRow {
            label: Translation.tr("settings.appearance.wallpaper")
            value: Config.background.wallpaperPath
            onValueChanged: Config.background.wallpaperPath = value
        }

        SwitchRow {
            label: Translation.tr("settings.appearance.parallax_effect")
            value: Config.background.parallax.enabled
            onToggled: Config.background.parallax.enabled = value
        }

        SliderRow {
            label: Translation.tr("settings.appearance.parallax_scale")
            value: Config.background.parallax.wallpaperScale
            from: 1.0
            to: 2.0
            step: 1
            suffix: "x"
            onValueChanged: Config.background.parallax.wallpaperScale = value
        }

        SwitchRow {
            label: Translation.tr("settings.appearance.dim_effect")
            value: Config.background.dim.enabled
            onToggled: Config.background.dim.enabled = value
        }

        SliderRow {
            label: Translation.tr("settings.appearance.dim_transparency")
            value: Config.background.dim.opacity
            from: 0.1
            to: 0.8
            step: 100
            suffix: "%"
            onValueChanged: Config.background.dim.opacity = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.appearance.theme")

        SwitchRow {
            label: Translation.tr("settings.appearance.dark_mode")
            value: Config.appearance.darkMode
            onToggled: Config.appearance.darkMode = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.appearance.transparency")

        SwitchRow {
            label: Translation.tr("settings.appearance.enable")
            value: Config.appearance.transparency.enabled
            onToggled: Config.appearance.transparency.enabled = value
        }
        SliderRow {
            label: Translation.tr("settings.appearance.alpha")
            value: Config.appearance.transparency.alpha
            from: 0.25
            to: 1
            step: 100
            suffix: "%"
            onValueChanged: Config.appearance.transparency.alpha = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.appearance.fonts")

        TextFieldRow {
            label: Translation.tr("settings.appearance.main_font")
            placeholder: "e.g Adwaita Sans"
            value: Config.appearance.fonts.main
            onValueChanged: Config.appearance.fonts.main = value
        }
        TextFieldRow {
            label: Translation.tr("settings.appearance.mono_font")
            placeholder: "e.g JetBrainsMono NF"
            value: Config.appearance.fonts.monospace
            onValueChanged: Config.appearance.fonts.monospace = value
        }
        TextFieldRow {
            label: Translation.tr("settings.appearance.nerd_font")
            placeholder: "e.g JetBrainsMono NF"
            value: Config.appearance.fonts.nerdFont
            onValueChanged: Config.appearance.fonts.nerdFont = value
        }
    }
}
