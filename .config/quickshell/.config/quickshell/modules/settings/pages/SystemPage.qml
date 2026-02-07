import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.modules.settings.components
import qs.common
import qs.widgets
import qs.services
import qs.config

ContentPage {
    title: Translation.tr("settings.system.title")

    ContentItem {
        title: Translation.tr("settings.system.bar")

        SpinBoxRow {
            label: Translation.tr("settings.system.height")
            value: Config.bar.height
            from: 30
            to: 100
            step: 5
            onValueChanged: Config.bar.height = value
        }

        SwitchRow {
            label: Translation.tr("settings.system.bottom_position")
            value: Config.bar.bottom
            onToggled: Config.bar.bottom = value
        }

        SwitchRow {
            label: Translation.tr("settings.system.floating")
            value: Config.bar.floating
            onToggled: Config.bar.floating = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.system.vertical_margins")
            value: Config.bar.margins.vertical
            from: 0
            to: 50
            onValueChanged: Config.bar.margins.vertical = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.system.horizontal_margins")
            value: Config.bar.margins.horizontal
            from: 0
            to: 50
            onValueChanged: Config.bar.margins.horizontal = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.system.workspaces_shown")
            value: Config.bar.workspaces.shown
            from: 1
            to: 10
            onValueChanged: Config.bar.workspaces.shown = value
        }

        SwitchRow {
            label: Translation.tr("settings.system.make_tray_monochrome")
            value: Config.bar.tray.monochromeTrayIcons
            onToggled: Config.bar.tray.monochromeTrayIcons = value
        }

        SliderRow {
            label: Translation.tr("settings.system.icon_desaturation")
            value: Config.bar.tray.desaturation
            from: 0
            to: 1
            step: 100
            suffix: "%"
            onValueChanged: Config.bar.tray.desaturation = value
        }

        SwitchRow {
            label: Translation.tr("settings.system.classic_battery")
            value: Config.bar.battery.classicBatteryStyle
            onToggled: Config.bar.battery.classicBatteryStyle = value
        }

        SwitchRow {
            label: Translation.tr("settings.system.show_percentage")
            value: Config.bar.battery.showPercentage
            onToggled: Config.bar.battery.showPercentage = value
        }

        SwitchRow {
            label: Translation.tr("settings.system.transparent_center_widgets")
            value: Config.bar.transparentCenterWidgets
            onToggled: Config.bar.transparentCenterWidgets = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.system.time")

        TextFieldRow {
            label: Translation.tr("settings.system.time_format")
            value: Config.time.format
            placeholder: "hh:mm"
            onValueChanged: Config.time.format = value
        }

        TextFieldRow {
            label: Translation.tr("settings.system.date_format")
            value: Config.time.dateFormat
            placeholder: "ddd, dd MMM"
            onValueChanged: Config.time.dateFormat = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.system.gamemode")

        SpinBoxRow {
            label: Translation.tr("settings.system.gaps_in")
            value: Config.gamemode.gapsIn
            from: 0
            to: 50
            onValueChanged: Config.gamemode.gapsIn = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.system.gaps_out")
            value: Config.gamemode.gapsOut
            from: 0
            to: 50
            onValueChanged: Config.gamemode.gapsOut = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.system.border_size")
            value: Config.gamemode.borderSize
            from: 0
            to: 20
            onValueChanged: Config.gamemode.borderSize = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.system.rounding")
            value: Config.gamemode.rounding
            from: 0
            to: 50
            onValueChanged: Config.gamemode.rounding = value
        }

        SwitchRow {
            label: Translation.tr("settings.system.send_notification")
            value: Config.gamemode.sendNotification
            onToggled: Config.gamemode.sendNotification = value
        }

        SwitchRow {
            label: Translation.tr("settings.system.disable_blur")
            value: Config.gamemode.blur.disableBlur
            onToggled: Config.gamemode.blur.disableBlur = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.system.blur_size")
            value: Config.gamemode.blur.blurSize
            from: 0
            to: 50
            enabled: !Config.gamemode.blur.disableBlur
            onValueChanged: Config.gamemode.blur.blurSize = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.system.blur_passes")
            value: Config.gamemode.blur.blurPasses
            from: 0
            to: 10
            enabled: !Config.gamemode.blur.disableBlur
            onValueChanged: Config.gamemode.blur.blurPasses = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.system.weather")

        SpinBoxRow {
            label: Translation.tr("settings.system.update_interval_minutes")
            value: Config.weather.updateInterval
            from: 1
            to: 60
            onValueChanged: Config.weather.updateInterval = value
        }

        TextFieldRow {
            label: Translation.tr("settings.system.city")
            value: Config.weather.city
            placeholder: Translation.tr("settings.system.city_placeholder")
            onValueChanged: Config.weather.city = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.system.notifications")

        SpinBoxRow {
            label: Translation.tr("settings.system.timeout_ms")
            value: Config.notification.timeout
            from: 1000
            to: 30000
            step: 500
            onValueChanged: Config.notification.timeout = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.system.osd")

        SpinBoxRow {
            label: Translation.tr("settings.system.timeout_ms")
            value: Config.osd.timeout
            from: 500
            to: 5000
            step: 100
            onValueChanged: Config.osd.timeout = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.system.lock_screen")

        SwitchRow {
            label: Translation.tr("settings.system.blur_enabled")
            value: Config.lock.blur.enabled
            onToggled: Config.lock.blur.enabled = value
        }

        SliderRow {
            label: Translation.tr("settings.system.blur_radius")
            value: Config.lock.blur.radius
            from: 0
            to: 50
            enabled: Config.lock.blur.enabled
            onValueChanged: Config.lock.blur.radius = value
        }

        SliderRow {
            label: Translation.tr("settings.system.dim_opacity")
            value: Config.lock.dimOpacity
            from: 0
            to: 1
            step: 100
            suffix: "%"
            onValueChanged: Config.lock.dimOpacity = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.system.language")

        TextFieldRow {
            label: Translation.tr("settings.system.interface_language")
            placeholder: "en"
            value: Config.system.locale
            onValueChanged: Config.system.locale = value
        }
    }
}
