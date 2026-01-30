import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
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
