import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.services

Item {
    id: root
    implicitWidth: text.implicitWidth
    implicitHeight: text.implicitHeight

    StyledText {
        id: text
        text: Hyprland.activeToplevel?.title || "jopa"
    }
}
