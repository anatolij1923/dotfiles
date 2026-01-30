import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.common
import qs.widgets
import qs.services

ContentPage {
    title: "General"

    ContentItem {
        title: "Information"

        StyledText {
            text: "Welcome to Chroma Settings"
            size: 18
            weight: 500
            color: Colors.palette.m3onSurface
            Layout.fillWidth: true
        }

        StyledText {
            text: "Configure your shell environment from here. All changes are saved automatically to config.json"
            size: 14
            color: Colors.palette.m3onSurfaceVariant
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.topMargin: Appearance.padding.normal
        }
    }
}
