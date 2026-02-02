import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.widgets
import qs.common
import qs.services

StyledWindow {
    id: root
    name: "activate"

    WlrLayershell.layer: WlrLayer.Overlay

    property int padding: Appearance.padding.huge

    implicitWidth: content.implicitWidth + padding * 5
    implicitHeight: content.implicitHeight + padding * 4

    anchors {
        bottom: true
        right: true
    }

    mask: Region {
        item: null
    }

    ColumnLayout {
        id: content
        anchors.centerIn: parent
        opacity: 0.8
        StyledText {
            text: "Activate Dotfiles"
            size: Appearance.font.size.xlarge
            weight: 500
        }
        StyledText {
            text: "Go to settings to activate dotfiles"
            size: Appearance.font.size.large
        }
    }
}
