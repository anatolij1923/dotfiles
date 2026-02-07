import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.common
import qs.widgets
import qs.services

ContentPage {
    title: Translation.tr("settings.general.title")

    ContentItem {
        title: Translation.tr("settings.general.information")

        StyledText {
            text: Translation.tr("settings.general.welcome")
            size: 18
            weight: 500
            color: Colors.palette.m3onSurface
            Layout.fillWidth: true
        }

        StyledText {
            text: Translation.tr("settings.general.configure_hint")
            size: 14
            color: Colors.palette.m3onSurfaceVariant
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.topMargin: Appearance.padding.normal
        }
    }
}
