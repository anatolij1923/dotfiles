import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.modules.settings.components
import qs.common
import qs.widgets
import qs.services
import qs.config

ContentPage {
    title: Translation.tr("settings.launcher.title")

    ContentItem {
        title: Translation.tr("settings.launcher.display")

        SpinBoxRow {
            label: Translation.tr("settings.launcher.max_items_shown")
            value: Config.launcher.maxShown
            from: 1
            to: 20
            onValueChanged: Config.launcher.maxShown = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.launcher.item_height")
            value: Config.launcher.sizes.itemHeight
            from: 40
            to: 100
            step: 5
            onValueChanged: Config.launcher.sizes.itemHeight = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.launcher.wallpaper_width")
            value: Config.launcher.sizes.wallWidth
            from: 200
            to: 600
            step: 10
            onValueChanged: Config.launcher.sizes.wallWidth = value
        }

        SpinBoxRow {
            label: Translation.tr("settings.launcher.wallpaper_height")
            value: Config.launcher.sizes.wallHeight
            from: 150
            to: 400
            step: 10
            onValueChanged: Config.launcher.sizes.wallHeight = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.launcher.stats")
        SwitchRow {
            label: Translation.tr("settings.launcher.stats_label")
            value: Config.launcher.useStatsForApps
            onToggled: Config.launcher.useStatsForApps = value
        }
    }

    ContentItem {
        title: Translation.tr("settings.launcher.commands")

        StyledText {
            text: Translation.tr("settings.launcher.commands_hint")
            color: Colors.palette.m3onSurfaceVariant
            size: 14
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        StyledText {
            text: Translation.tr("settings.launcher.total_commands").replace("%1", Config.launcher.commands.length)
            color: Colors.palette.m3onSurfaceVariant
            size: 14
        }
    }
}
