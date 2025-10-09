import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.modules.background
import qs.modules.bar
import qs.modules.corners
import qs.modules.lock
import qs.modules.powermenu
import qs.modules.launcher
import qs.modules.quicksettings

ShellRoot {
    property bool enableBackground: true
    property bool enableBar: true
    property bool enableReloadPopup: true
    property bool enableScreenCorners: true
    property bool enableLock: true
    property bool enablePowermenu: true
    property bool enableLauncher: true
    property bool enableQuicksettings: true

    LazyLoader {
        active: enableBackground
        component: Background {}
    }
    LazyLoader {
        active: enableBar
        component: Bar {}
    }
    LazyLoader {
        active: enableReloadPopup
        component: ReloadPopup {}
    }

    LazyLoader {
        active: enableScreenCorners
        component: ScreenCorners {}
    }

    LazyLoader {
        active: enableLock
        component: Lock {}
    }
    LazyLoader {
        active: enablePowermenu
        component: Powermenu {}
    }
    LazyLoader {
        active: enableLauncher
        component: Launcher {}
    }
    LazyLoader {
        active: enableQuicksettings
        component: Quicksettings {}
    }
}
