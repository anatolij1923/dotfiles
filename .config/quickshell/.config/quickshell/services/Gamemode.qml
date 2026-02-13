pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import qs.config
import qs.common

Singleton {
    id: root

    property bool enabled: false

    function enable() {
        if (!root.enabled) {
            Quickshell.execDetached(["bash", "-c", `hyprctl --batch "keyword animations:enabled 0;
            keyword input:touchpad:disable_while_typing 0;
            keyword decoration:shadow:enabled 0;
            keyword decoration:blur:enabled ${!Config.gamemode.blur.disableBlur};
            keyword decoration:blur:passes ${Config.gamemode.blur.blurPasses};
            keyword decoration:blur:size ${Config.gamemode.blur.blurSize};
            keyword general:gaps_in ${Config.gamemode.gapsIn};
            keyword general:gaps_out ${Config.gamemode.gapsOut};
            keyword general:border_size ${Config.gamemode.borderSize};
            keyword decoration:rounding ${Config.gamemode.rounding};
            keyword general:allow_tearing 1" `]);
            if (Config.gamemode.sendNotification) {
                Quickshell.execDetached(["notify-send", "Gamemode", "Gamemode enabled", "-a", "shell"]);
            }
            root.enabled = true;
        } else {
            Quickshell.execDetached(["hyprctl", "reload"]);
            if (Config.gamemode.sendNotification) {
                Quickshell.execDetached(["notify-send", "Gamemode", "Gamemode disabled", "-a", "shell"]);
            }
            root.enabled = false;
        }
    }

    Process {
        id: fetch
        running: true
        command: ["bash", "-c", `test "$(hyprctl getoption animations:enabled -j | jq ".int")" -ne 0`]
        onExited: exitCode => {
            root.enabled = exitCode !== 0;
        }
    }
    function init() {
    }

    IpcHandler {
        target: "gamemode"

        function toggle(): void {
            root.enable();
        }
    }

    GlobalShortcut {
        name: "toggleGamemode"
        description: "Toggle game mode"
        onPressed: {
            root.enable();
        }
    }
}
