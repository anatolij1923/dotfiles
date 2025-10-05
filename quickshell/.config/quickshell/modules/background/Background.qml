pragma ComponentBehavior: Bound  
  
import Quickshell  
import Quickshell.Wayland  
import Quickshell.Hyprland  
import QtQuick  
import QtQuick.Effects  
  
import qs  
  
Variants {  
    id: root  
    model: Quickshell.screens  
  
    PanelWindow {  
        id: bgRoot  
  
        required property var modelData  
  
        // Workspace tracking for parallax  
        property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)  
        property list<var> relevantWindows: HyprlandData.windowList.filter(win => win.monitor == monitor?.id && win.workspace.id >= 0).sort((a, b) => a.workspace.id - b.workspace.id)  
        property int firstWorkspaceId: relevantWindows[0]?.workspace.id || 1  
        property int lastWorkspaceId: relevantWindows[relevantWindows.length - 1]?.workspace.id || 10  
  
        // Parallax calculation properties  
        property real wallpaperScale: 1.07  // Zoom factor to enable parallax movement  
        property real movableXSpace: (bgRoot.width * wallpaperScale - bgRoot.width) / 2  
        property real movableYSpace: (bgRoot.height * wallpaperScale - bgRoot.height) / 2  
  
        screen: modelData  
        exclusionMode: ExclusionMode.Ignore  
        WlrLayershell.layer: GlobalStates.screenLocked ? WlrLayer.Overlay : WlrLayer.Bottom  
        color: "transparent"  
  
        anchors {  
            top: true  
            bottom: true  
            left: true  
            right: true  
        }  
  
        // Wallpaper  
        Item {  
            anchors.fill: parent  
            clip: true  
  
            Image {  
                id: wallpaper  
                asynchronous: true  
                fillMode: Image.PreserveAspectCrop  
                  
                // Parallax positioning  
                property int chunkSize: 10  // Workspace range  
                property int lower: Math.floor(bgRoot.firstWorkspaceId / chunkSize) * chunkSize  
                property int upper: Math.ceil(bgRoot.lastWorkspaceId / chunkSize) * chunkSize  
                property int range: upper - lower  
                  
                property real valueX: {  
                    let result = 0.5;  
                    // Workspace-based parallax  
                    result = ((bgRoot.monitor.activeWorkspace?.id - lower) / range);  
                    // Sidebar-based parallax (optional)  
                    result += (0.15 * GlobalStates.sidebarRightOpen - 0.15 * GlobalStates.sidebarLeftOpen);  
                    return result;  
                }  
                  
                property real effectiveValueX: Math.max(0, Math.min(1, valueX))  
                  
                // Apply parallax offset  
                x: -(bgRoot.movableXSpace) - (effectiveValueX - 0.5) * 2 * bgRoot.movableXSpace  
                y: -(bgRoot.movableYSpace)  
                  
                // Smooth animation  
                Behavior on x {  
                    NumberAnimation {  
                        duration: 600  
                        easing.type: Easing.OutCubic  
                    }  
                }  
                  
                sourceSize: Qt.size(bgRoot.width * wallpaperScale, bgRoot.height * wallpaperScale)  
                width: bgRoot.width * wallpaperScale  
                height: bgRoot.height * wallpaperScale  
                source: "file:///home/anatolij1923/Изображения/wallpapers/1923\ Pack/Lowpoly_Street.png"  
            }  
        }  
    }  
}
