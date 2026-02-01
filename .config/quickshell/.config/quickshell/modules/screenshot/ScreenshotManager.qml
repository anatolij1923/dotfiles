pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import qs
import qs.common

Scope {
    id: root

    function capture(screen, rect, mode) {
        const s = screen.devicePixelRatio || 1.0;
        const x = Math.round((screen.x + rect.x) * s);
        const y = Math.round((screen.y + rect.y) * s);
        const w = Math.round(rect.w * s);
        const h = Math.round(rect.h * s);

        const screenshotDir = `${Paths.strip(Paths.pictures)}/Screenshots`;
        const geometry = `${x},${y} ${w}x${h}`;
        const timestamp = Qt.formatDateTime(new Date(), "yyyyMMdd_HHmmss");
        const fileName = `Screenshot_${timestamp}.png`;
        const fullPath = `${screenshotDir}/${fileName}`;
        const prepareDir = `mkdir -p "${screenshotDir}"`;

        let cmd = "";
        switch (mode) {
        case "copy":
            cmd = `${prepareDir} && grim -g "${geometry}" - | wl-copy && notify-send -a "shell" "Screenshot" "Copied to clipboard"`;
            break;
        case "save":
            cmd = `${prepareDir} && grim -g "${geometry}" "${fullPath}" && notify-send -a "shell" "Screenshot" "Saved at: ${fullPath}"`;
            break;
        case "edit":
            cmd = `grim -g "${geometry}" - | satty --filename -`;
            break;
        case "ocr":
            // 1. Get the list of languages: tesseract --list-langs
            // 2. Skip first line: awk 'NR>1{print $1}'
            // 3. Join with '+': tr '\n' '+'
            // 4. Remove trailing plus: sed 's/+$//'
            let getLangs = "tesseract --list-langs | awk 'NR>1{print $1}' | tr '\\n' '+' | sed 's/+$//'";
            // tesseract stdin stdout - outputs directly to pipes
            cmd = `grim -g "${geometry}" - | tesseract stdin stdout -l "$(${getLangs})" | wl-copy && notify-send -a "shell" "Screenshot" "Text copied to clipboard"`;
            break;
        }

        Logger.s("SCREENSHOT", `Capture [${mode.toUpperCase()}]: ${geometry}`);
        Quickshell.execDetached(["sh", "-c", cmd]);
    }

    // Helper for fullscreen
    function captureFullscreen(mode) {
        // Use focused monitor or the first available screen
        const monitor = Hyprland.focusedMonitor;
        const screen = Quickshell.screens.find(s => s.name === monitor.name) || Quickshell.screens[0];

        root.capture(screen, {
            x: 0,
            y: 0,
            w: screen.width,
            h: screen.height
        }, mode);
    }

    Loader {
        active: GlobalStates.screenshotOpened
        sourceComponent: Variants {
            model: Quickshell.screens
            delegate: ScreenshotUI {
                manager: root
            }
        }
    }

    IpcHandler {
        target: "screenshot"

        function toggle(): void {
            GlobalStates.screenshotOpened = !GlobalStates.screenshotOpened;
        }

        function fullscreenCopy(): void {
            root.captureFullscreen("copy");
        }
        function fullscreenSave(): void {
            root.captureFullscreen("save");
        }
    }
}
