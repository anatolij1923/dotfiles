pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import qs
import qs.common

Scope {
    id: root

    readonly property string screenshotDir: `${Paths.strip(Paths.pictures)}/Screenshots`

    function runAction(mode, screen, rect) {
        const s = screen.devicePixelRatio || 1.0;

        const x = Math.round((screen.x + rect.x) * s);
        const y = Math.round((screen.y + rect.y) * s);
        const w = Math.round(rect.w * s);
        const h = Math.round(rect.h * s);
        const geometry = `${x},${y} ${w}x${h}`;

        const timestamp = Qt.formatDateTime(new Date(), "yyyyMMdd_HHmmss");
        const fullPath = `${screenshotDir}/Screenshot_${timestamp}.png`;
        const prepareDir = `mkdir -p "${screenshotDir}"`;

        const commands = {
            "copy": `${prepareDir} && grim -g "${geometry}" - | wl-copy && notify-send -a "shell" "Screenshot" "Copied to clipboard"`,
            "save": `${prepareDir} && grim -g "${geometry}" "${fullPath}" && notify-send -a "shell" "Screenshot" "Saved at: ${fullPath}"`,
            "edit": `grim -g "${geometry}" - | satty --filename -`,
            "ocr": `grim -g "${geometry}" - | tesseract stdin stdout -l "$(tesseract --list-langs | awk 'NR>1{print $1}' | tr '\\n' '+' | sed 's/+$//')" | wl-copy && notify-send -a "shell" "Picker" "Text copied to clipboard"`
        };

        const cmd = commands[mode];
        if (cmd) {
            Logger.s("PICKER", `Action [${mode.toUpperCase()}]: ${geometry}`);
            Quickshell.execDetached(["sh", "-c", cmd]);
        }
    }

    function captureFullscreen(mode) {
        const monitor = Hyprland.focusedMonitor;
        const screen = Quickshell.screens.find(s => s.name === monitor.name) || Quickshell.screens[0];

        root.runAction(mode, screen, {
            x: 0,
            y: 0,
            w: screen.width,
            h: screen.height
        });
    }

    Loader {
        active: GlobalStates.pickerOpened
        sourceComponent: Variants {
            model: Quickshell.screens
            delegate: PickerOverlay {
                manager: root
            }
        }
    }

    IpcHandler {
        target: "picker" 

        function toggle(): void {
            GlobalStates.pickerOpened = !GlobalStates.pickerOpened;
        }

        function fullscreenCopy(): void {
            root.captureFullscreen("copy");
        }

        function fullscreenSave(): void {
            root.captureFullscreen("save");
        }
    }

    GlobalShortcut {
        name: "togglePicker"
        onPressed: {
            GlobalStates.pickerOpened = !GlobalStates.pickerOpened
        }
    }
    GlobalShortcut {
        name: "fullscreenCopy"
        onPressed: {
            root.captureFullscreen("copy")
        }
    }
    GlobalShortcut {
        name: "fullscreenSave"
        onPressed: {
            root.captureFullscreen("save")
        }
    }
}
