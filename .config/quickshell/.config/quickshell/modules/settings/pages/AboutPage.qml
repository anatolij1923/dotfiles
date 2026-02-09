import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.modules.settings.components
import qs.config
import qs.common
import qs.widgets
import qs.services

ContentPage {
    title: Translation.tr("settings.about.title")

    ContentItem {
        title: Translation.tr("settings.about.chroma_shell")

        StyledText {
            text: Translation.tr("settings.about.chroma_settings")
            size: 18
            weight: 500
            color: Colors.palette.m3onSurface
            Layout.fillWidth: true
        }

        StyledText {
            text: Translation.tr("settings.about.description")
            size: 14
            color: Colors.palette.m3onSurfaceVariant
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.topMargin: Appearance.spacing.md
        }

        SwitchRow {
            label: Translation.tr("settings.about.activate_dotfiles")
            value: Config.system.dotfilesActivated
            onToggled: Config.system.dotfilesActivated = value
        }
    }
}
