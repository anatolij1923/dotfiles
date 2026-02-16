import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.common
import qs.widgets
import qs.services
import qs.config

ContentPage {
    title: Translation.tr("settings.bar.title")

    ContentItem {
        title: Translation.tr("settings.bar.positioning")

        SpinBoxRow {
            label: Translation.tr("settings.bar.height")
            value: Config.bar.height
            from: 40
            to: 60
            step: 5
            onValueChanged: Config.bar.height = value
        }

        SwitchRow {
            label: Translation.tr("settings.bar.bottom_position")
            value: Config.bar.bottom
            onToggled: Config.bar.bottom = value
        }

        SwitchRow {
            label: Translation.tr("settings.bar.floating")
            value: Config.bar.floating
            onToggled: Config.bar.floating = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.bar.vertical_margins")
            value: Config.bar.margins.vertical
            from: 0
            to: 50
            onValueChanged: Config.bar.margins.vertical = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.bar.horizontal_margins")
            value: Config.bar.margins.horizontal
            from: 0
            to: 50
            onValueChanged: Config.bar.margins.horizontal = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.bar.tray")
        SwitchRow {
            label: Translation.tr("settings.bar.make_tray_monochrome")
            value: Config.bar.tray.monochromeTrayIcons
            onToggled: Config.bar.tray.monochromeTrayIcons = value
        }

        SliderRow {
            label: Translation.tr("settings.bar.icon_desaturation")
            value: Config.bar.tray.desaturation
            from: 0
            to: 1
            step: 100
            suffix: "%"
            onValueChanged: Config.bar.tray.desaturation = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.bar.battery")

        SwitchRow {
            label: Translation.tr("settings.bar.classic_battery")
            value: Config.bar.battery.classicBatteryStyle
            onToggled: Config.bar.battery.classicBatteryStyle = value
        }

        SwitchRow {
            label: Translation.tr("settings.bar.show_percentage")
            value: Config.bar.battery.showPercentage
            onToggled: Config.bar.battery.showPercentage = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.bar.workspaces")
        SpinBoxRow {
            label: Translation.tr("settings.bar.workspaces_shown")
            value: Config.bar.workspaces.shown
            from: 1
            to: 10
            onValueChanged: Config.bar.workspaces.shown = value
        }

        SwitchRow {
            label: Translation.tr("settings.bar.transparent_center_widgets")
            value: Config.bar.transparentCenterWidgets
            onToggled: Config.bar.transparentCenterWidgets = value
        }
    }
}
