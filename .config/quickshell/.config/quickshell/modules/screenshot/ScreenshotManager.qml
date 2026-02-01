import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import qs

Scope {
    Loader {
        active: GlobalStates.screenshotOpened

        sourceComponent: Variants {
            model: Quickshell.screens

            delegate: ScreenshotUI {}
        }
    }

    // GlobalShortcut {
    //     name: "TakeScreenshot"
    //     description: "Select region and copy to clipboard"
    //     onPressed: root.start()
    // }

    IpcHandler {
        target: "screenshot"

        function toggle(): void {
            GlobalStates.screenshotOpened = !GlobalStates.screenshotOpened;
        }
    }
}
