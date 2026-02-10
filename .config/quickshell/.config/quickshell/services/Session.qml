pragma Singleton
import qs.services

import Quickshell

Singleton {
    id: root

    function lock() {
        Quickshell.execDetached(["loginctl", "lock-session"]);
    }

    function poweroff() {
        Quickshell.execDetached(["bash", "-c", `systemctl poweroff || loginctl poweroff`]);
    }

    function reboot() {
        Quickshell.execDetached(["bash", "-c", `reboot || loginctl reboot`]);
    }

    function suspend() {
        Quickshell.execDetached(["bash", "-c", "systemctl suspend || loginctl suspend"]);
    }

    function logout() {
        HyprlandData.dispatch("exit");
    }
}
