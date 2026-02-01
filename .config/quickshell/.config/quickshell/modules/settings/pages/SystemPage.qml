import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.modules.settings.components
import qs.common
import qs.widgets
import qs.services
import qs.config

ContentPage {
    title: "System"

    ContentItem {
        title: "Bar"

        SpinBoxRow {
            label: "Height"
            value: Config.bar.height
            from: 30
            to: 100
            step: 5
            onValueChanged: Config.bar.height = value
        }

        SwitchRow {
            label: "Bottom position"
            value: Config.bar.bottom
            onToggled: Config.bar.bottom = value
        }

        SwitchRow {
            label: "Floating"
            value: Config.bar.floating
            onToggled: Config.bar.floating = value
        }

        SpinBoxRow {
            label: "Vertical Margins"
            value: Config.bar.margins.vertical
            from: 0
            to: 50
            onValueChanged: Config.bar.margins.vertical = value
        }

        SpinBoxRow {
            label: "Horizontal Margins"
            value: Config.bar.margins.horizontal
            from: 0
            to: 50
            onValueChanged: Config.bar.margins.horizontal = value
        }

        SpinBoxRow {
            label: "Workspaces shown"
            value: Config.bar.workspaces.shown
            from: 1
            to: 10
            onValueChanged: Config.bar.workspaces.shown = value
        }

        SwitchRow {
            label: "Make tray icons monochrome"
            value: Config.bar.tray.monochromeTrayIcons
            onToggled: Config.bar.tray.monochromeTrayIcons = value
        }

        SliderRow {
            label: "Icon desaturation"
            value: Config.bar.tray.desaturation
            from: 0
            to: 1
            // step: 99
            // suffix: "%"
            onValueChanged: Config.bar.tray.desaturation = value
        }

        SwitchRow {
            label: "Use classic battery style"
            value: Config.bar.battery.classicBatteryStyle
            onToggled: Config.bar.battery.classicBatteryStyle = value
        }

        SwitchRow {
            label: "Show percentage"
            value: Config.bar.battery.showPercentage
            onToggled: Config.bar.battery.showPercentage = value
        }
    }

    ContentItem {
        title: "Time"

        TextFieldRow {
            label: "Time format"
            value: Config.time.format
            placeholder: "hh:mm"
            onValueChanged: Config.time.format = value
        }

        TextFieldRow {
            label: "Date format"
            value: Config.time.dateFormat
            placeholder: "ddd, dd MMM"
            onValueChanged: Config.time.dateFormat = value
        }
    }

    ContentItem {
        title: "Gamemode"

        SpinBoxRow {
            label: "Gaps in"
            value: Config.gamemode.gapsIn
            from: 0
            to: 50
            onValueChanged: Config.gamemode.gapsIn = value
        }

        SpinBoxRow {
            label: "Gaps out"
            value: Config.gamemode.gapsOut
            from: 0
            to: 50
            onValueChanged: Config.gamemode.gapsOut = value
        }

        SpinBoxRow {
            label: "Border size"
            value: Config.gamemode.borderSize
            from: 0
            to: 20
            onValueChanged: Config.gamemode.borderSize = value
        }

        SpinBoxRow {
            label: "Rounding"
            value: Config.gamemode.rounding
            from: 0
            to: 50
            onValueChanged: Config.gamemode.rounding = value
        }

        SwitchRow {
            label: "Send notification"
            value: Config.gamemode.sendNotification
            onToggled: Config.gamemode.sendNotification = value
        }

        SwitchRow {
            label: "Disable blur"
            value: Config.gamemode.blur.disableBlur
            onToggled: Config.gamemode.blur.disableBlur = value
        }

        SpinBoxRow {
            label: "Blur size"
            value: Config.gamemode.blur.blurSize
            from: 0
            to: 50
            enabled: !Config.gamemode.blur.disableBlur
            onValueChanged: Config.gamemode.blur.blurSize = value
        }

        SpinBoxRow {
            label: "Blur passes"
            value: Config.gamemode.blur.blurPasses
            from: 0
            to: 10
            enabled: !Config.gamemode.blur.disableBlur
            onValueChanged: Config.gamemode.blur.blurPasses = value
        }
    }

    ContentItem {
        title: "Weather"

        SpinBoxRow {
            label: "Update interval (minutes)"
            value: Config.weather.updateInterval
            from: 1
            to: 60
            onValueChanged: Config.weather.updateInterval = value
        }

        TextFieldRow {
            label: "City"
            value: Config.weather.city
            placeholder: "Enter city name"
            onValueChanged: Config.weather.city = value
        }
    }

    ContentItem {
        title: "Notifications"

        SpinBoxRow {
            label: "Timeout (ms)"
            value: Config.notification.timeout
            from: 1000
            to: 30000
            step: 500
            onValueChanged: Config.notification.timeout = value
        }
    }

    ContentItem {
        title: "OSD"

        SpinBoxRow {
            label: "Timeout (ms)"
            value: Config.osd.timeout
            from: 500
            to: 5000
            step: 100
            onValueChanged: Config.osd.timeout = value
        }
    }

    ContentItem {
        title: "Lock Screen"

        SwitchRow {
            label: "Blur enabled"
            value: Config.lock.blur.enabled
            onToggled: Config.lock.blur.enabled = value
        }

        SliderRow {
            label: "Blur radius"
            value: Config.lock.blur.radius
            from: 0
            to: 50
            enabled: Config.lock.blur.enabled
            onValueChanged: Config.lock.blur.radius = value
        }

        SliderRow {
            label: "Dim opacity"
            value: Config.lock.dimOpacity
            from: 0
            to: 1
            suffix: "%"
            onValueChanged: Config.lock.dimOpacity = value
        }
    }
}
