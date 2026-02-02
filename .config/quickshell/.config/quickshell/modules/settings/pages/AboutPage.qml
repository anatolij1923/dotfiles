import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.modules.settings.components
import qs.config
import qs.common
import qs.widgets
import qs.services

ContentPage {
    title: "About"

    ContentItem {
        title: "Chroma Shell"

        StyledText {
            text: "Chroma Shell Settings"
            size: 18
            weight: 500
            color: Colors.palette.m3onSurface
            Layout.fillWidth: true
        }

        StyledText {
            text: "A modern, customizable shell environment built with Quickshell"
            size: 14
            color: Colors.palette.m3onSurfaceVariant
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.topMargin: Appearance.padding.normal
        }

        SwitchRow {
            label: "Activate dotfiles"
            value: Config.background.dotfilesActivated
            onToggled: Config.background.dotfilesActivated = value
        }
    }
}
