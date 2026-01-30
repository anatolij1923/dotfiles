import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.modules.settings.components
import qs.common
import qs.widgets
import qs.services
import qs.config

ContentPage {
    title: "Launcher"

    ContentItem {
        title: "Display"

        SpinBoxRow {
            label: "Max items shown"
            value: Config.launcher.maxShown
            from: 1
            to: 20
            onValueChanged: Config.launcher.maxShown = value
        }

        SpinBoxRow {
            label: "Item height"
            value: Config.launcher.sizes.itemHeight
            from: 40
            to: 100
            step: 5
            onValueChanged: Config.launcher.sizes.itemHeight = value
        }

        SpinBoxRow {
            label: "Wallpaper width"
            value: Config.launcher.sizes.wallWidth
            from: 200
            to: 600
            step: 10
            onValueChanged: Config.launcher.sizes.wallWidth = value
        }

        SpinBoxRow {
            label: "Wallpaper height"
            value: Config.launcher.sizes.wallHeight
            from: 150
            to: 400
            step: 10
            onValueChanged: Config.launcher.sizes.wallHeight = value
        }
    }

    ContentItem {
        title: "Commands"

        StyledText {
            text: "Commands configuration is available in config.json file"
            color: Colors.palette.m3onSurfaceVariant
            size: 14
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        StyledText {
            text: "Total commands: " + Config.launcher.commands.length
            color: Colors.palette.m3onSurfaceVariant
            size: 14
        }
    }
}
