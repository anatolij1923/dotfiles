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
                    if (val === "wallhaven")
                        RandomWallpaper.fetchWallhaven();
                    else
                        RandomWallpaper.fetchKonachan();
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

        ButtonGroup {
            model: ["Tonal Spot", "Content", "Expressive", "Fidelity", "Fruit Salad", "Monochrome", "Neutral", "Rainbow", "Vibrant"].map(n => ({
                        text: n,
                        value: "scheme-" + n.toLowerCase().replace(" ", "-")
                    }))
            wrap: true
            inactiveColor: Colors.palette.m3secondaryContainer
            currentValue: Config.appearance.theming.schemeType
            onSelected: val => {
                Config.appearance.theming.schemeType = val;
                Colors.generateColors();
            }
        }

        // ButtonGroup {
        //     // Убираем ClippingRectangle или ставим ему color: transparent,
        //     // так как теперь кнопки сами отвечают за свои углы.
        //
        //     Repeater {
        //         id: schemes // Даем ID, чтобы обращаться к schemes.count
        //         model: ["Tonal Spot", "Content", "Expressive", "Fidelity", "Fruit Salad", "Monochrome", "Neutral", "Rainbow", "Vibrant"]
        //
        //         delegate: TextButton {
        //             readonly property string schemeId: "scheme-" + modelData.toLowerCase().replace(" ", "-")
        //
        //             text: modelData
        //             checked: Config.appearance.theming.schemeType === schemeId
        //
        //             radius: {
        //                 if (checked) {
        //                     return Appearance.rounding.xl;
        //                 } else {
        //                     return Appearance.rounding.sm;
        //                 }
        //             }
        //
        //             topLeftRadius: {
        //                 if (index === 0) {
        //                     return Appearance.rounding.xl;
        //                 }
        //             }
        //             bottomLeftRadius: {
        //                 if (index === 0) {
        //                     return Appearance.rounding.xl;
        //                 }
        //             }
        //             topRightRadius: {
        //                 if (index === schemes.count - 1) {
        //                     return Appearance.rounding.xl;
        //                 }
        //             }
        //             bottomRightRadius: {
        //                 if (index === schemes.count - 1) {
        //                     return Appearance.rounding.xl;
        //                 }
        //             }
        //
        //             // ЛОГИКА Скругления (M3 Style):
        //             // radius: {
        //             //     // 1. Если кнопка выбрана — она всегда "капсула" (максимальный радиус)
        //             //     if (checked)
        //             //         return Appearance.rounding.xl;
        //             //
        //             //     // 2. Если это первая кнопка в списке
        //             //     if (index === 0)
        //             //         return Appearance.rounding.lg;
        //             //
        //             //     // 3. Если это последняя кнопка в списке
        //             //     if (index === schemes.count - 1)
        //             //         return Appearance.rounding.lg;
        //             //
        //             //     // 4. Для всех остальных внутренних кнопок
        //             //     return Appearance.rounding.sm;
        //             // }
        //
        //             // Добавим небольшие отступы, чтобы M3 эффект был заметен
        //             inactiveColor: Colors.palette.m3secondaryContainer
        //             verticalPadding: Appearance.spacing.md
        //             horizontalPadding: Appearance.spacing.xl
        //
        //             onClicked: {
        //                 Config.appearance.theming.schemeType = schemeId;
        //                 Colors.generateColors();
        //             }
        //         }
        //     }
        // }
        //
        // ButtonGroup {
        //     Repeater {
        //         model: ["Tonal Spot", "Content", "Expressive", "Fidelity", "Fruit Salad"]
        //
        //         delegate: TextButton {
        //             readonly property string schemeId: "scheme-" + modelData.toLowerCase().replace(" ", "-")
        //
        //             text: modelData
        //             checked: Config.appearance.theming.schemeType === schemeId
        //
        //             inactiveColor: Colors.palette.m3secondaryContainer
        //             radius: checked ? Appearance.rounding.xl : Appearance.rounding.sm
        //
        //             verticalPadding: Appearance.spacing.md
        //             horizontalPadding: Appearance.spacing.xl
        //
        //             onClicked: {
        //                 Config.appearance.theming.schemeType = schemeId;
        //                 Colors.generateColors();
        //             }
        //         }
        //     }
        // }
        // ButtonGroup {
        //     Repeater {
        //         model: ["Monochrome", "Neutral", "Rainbow", "Vibrant"]
        //
        //         delegate: TextButton {
        //             readonly property string schemeId: "scheme-" + modelData.toLowerCase().replace(" ", "-")
        //
        //             text: modelData
        //             checked: Config.appearance.theming.schemeType === schemeId
        //
        //             inactiveColor: Colors.palette.m3secondaryContainer
        //             radius: checked ? Appearance.rounding.xl : Appearance.rounding.sm
        //
        //             verticalPadding: Appearance.spacing.md
        //             horizontalPadding: Appearance.spacing.xl
        //
        //             onClicked: {
        //                 Config.appearance.theming.schemeType = schemeId;
        //                 Colors.generateColors();
        //             }
        //         }
        //     }
        // }
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
