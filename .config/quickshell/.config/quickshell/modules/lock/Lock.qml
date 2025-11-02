pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.modules.lock
import qs

Scope {
    id: root

    LockContext {
        id: lockContext
        onUnlocked: {
            unlockTimer.start();
        }
    }

    Timer {
        id: unlockTimer
        interval: 200
        repeat: false
        onTriggered: {
            GlobalStates.screenLocked = false;

            // refocus on window
            Quickshell.execDetached(["bash", "-c", `sleep 0.2; hyprctl --batch "dispatch togglespecialworkspace; dispatch togglespecialworkspace"`]);
        }
    }

    WlSessionLock {
        id: lock
        locked: GlobalStates.screenLocked

        LockSurface {
            context: lockContext
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: Scope {
            required property ShellScreen modelData
            property bool shouldPush: GlobalStates.screenLocked
            property string targetMonitorName: modelData.name
            property int verticalMovementDistance: modelData.height
            property int horizontalSqueeze: modelData.width * 0.2
            // onShouldPushChanged: {
            //     if (shouldPush) {
            //         Quickshell.execDetached(["bash", "-c", `hyprctl keyword monitor ${targetMonitorName}, addreserved, ${verticalMovementDistance}, ${-verticalMovementDistance}, ${horizontalSqueeze}, ${horizontalSqueeze}`]);
            //     } else {
            //         Quickshell.execDetached(["bash", "-c", `hyprctl keyword monitor ${targetMonitorName}, addreserved, 0, 0, 0, 0`]);
            //     }
            // }
        }
    }

    IpcHandler {
        target: "lock"

        function activate(): void {
            GlobalStates.screenLocked = true;
        }
        function focus(): void {
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

    GlobalShortcut {
        name: "lockFocus"
        description: "Re-focuses the lock screen. This is because Hyprland after waking up for whatever reason" + "decides to keyboard-unfocus the lock screen"

        onPressed: {
            // console.log("I BEG FOR PLEAS REFOCUZ")
            lockContext.shouldReFocus();
        }
    }
}
