pragma Singleton
import qs.services

import Quickshell

Singleton {
    id: root
    // function closeAllWindows() {
    //     Hyprland.windowList.map(w => w.pid).forEach(pid => {
    //         Quickshell.execDetached(["kill", pid]);
    //     });
    // }

    function lock() {
        Quickshell.execDetached(["loginctl", "lock-session"]);
    }

    function poweroff() {
        // closeAllWindows();
        Quickshell.execDetached(["bash", "-c", `systemctl poweroff || loginctl poweroff`]);
    }

    function reboot() {
        // closeAllWindows();
        Quickshell.execDetached(["bash", "-c", `reboot || loginctl reboot`]);
    }

    function suspend() {
        Quickshell.execDetached(["bash", "-c", "systemctl suspend || loginctl suspend"]);
    }

    function logout() {
        // closeAllWindows();
        // Quickshell.execDetached(["pkill", "Hyprland"]);
        Hyprland.dispatch("exit");
    }
}
