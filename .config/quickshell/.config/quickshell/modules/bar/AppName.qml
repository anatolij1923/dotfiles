import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import qs.services
import qs.modules.common

Item {
    id: root

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel
    property string activeWindowAddress: `0x${activeWindow?.HyprlandToplevel?.address}`

    implicitWidth: appName.implicitWidth
    implicitHeight: appName.implicitHeight

    StyledText {
        id: appName
        text: root.activeWindow?.appId
    }
}
