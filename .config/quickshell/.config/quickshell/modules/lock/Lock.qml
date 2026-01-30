pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.modules.lock
import qs
import qs.common

Scope {
    id: lockRoot

    LockContext {
        id: lockContext
        onUnlocked: {
            GlobalStates.screenUnlocking = true;
            unlockTimer.start();
        }
    }

    Timer {
        id: unlockTimer
        interval: Appearance.animDuration.normal * 0.8
        repeat: false
        onTriggered: {
            GlobalStates.screenLocked = false;
            GlobalStates.screenUnlocking = false;

            Quickshell.execDetached(["bash", "-c", `sleep 0.1; hyprctl --batch "dispatch togglespecialworkspace; dispatch togglespecialworkspace"`]);
        }
    }

    WlSessionLock {
        id: lock
        locked: GlobalStates.screenLocked
        LockSurface {
            context: lockContext
        }
    }

    IpcHandler {
        target: "lock"
        function activate() {
            GlobalStates.screenLocked = true;
        }
        function focus() {
            lockContext.shouldReFocus();
        }
    }

    GlobalShortcut {
        name: "lock"
        description: "Locks the screen"

        onPressed: {
            GlobalStates.screenLocked = true;
        }
    }
}
