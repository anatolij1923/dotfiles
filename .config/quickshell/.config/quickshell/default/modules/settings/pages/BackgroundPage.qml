import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import qs.modules.settings
import qs.common
import qs.widgets
import qs.services
import qs.config

ContentPage {
    title: Translation.tr("settings.background.title")

    ContentItem {
        title: Translation.tr("settings.background.background")

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

            ButtonGroup {
                property string lastWallpaperSource: ""
                model: [
                    {
                        text: Translation.tr("settings.appearance.random_wallhaven"),
                        value: "wallhaven",
                        icon: "wallpaper"
                    },
                    {
                        text: Translation.tr("settings.appearance.random_konachan"),
                        value: "konachan",
                        icon: "wallpaper"
                    }
                ]

                wrap: true
                inactiveColor: Colors.palette.m3secondaryContainer
                currentValue: RandomWallpaper.isLoading ? lastWallpaperSource : ""

                onSelected: val => {
                    lastWallpaperSource = val;
                    if (val === "wallhaven") {
                        RandomWallpaper.fetchWallhaven();
                    } else {
                        RandomWallpaper.fetchKonachan();
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
            step: 0.01
            suffix: "%"
            onValueChanged: Config.background.dim.opacity = value
        }

        SwitchRow {
            label: Translation.tr("settings.appearance.zoom_effect")
            value: Config.background.zoom.enabled
            onToggled: Config.background.zoom.enabled = value
        }

        SliderRow {
            label: Translation.tr("settings.appearance.zoom_scale")
            value: Config.background.zoom.scale
            from: 1
            to: 1.2
            step: 1
            suffix: "x"
            onValueChanged: Config.background.zoom.scale = value
        }
    }
}
