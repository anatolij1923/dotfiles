//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_SCALE_FACTOR=1
//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_SCALE_FACTOR=1
import Quickshell
import QtQuick
import qs.config
import qs.services

import qs.modules.background
import qs.modules.bar
import qs.modules.corners
import qs.modules.lock
import qs.modules.powermenu
import qs.modules.launcher
import qs.modules.notifications
import qs.modules.tit
import qs.modules.quicksettings
import qs.modules.osd
import qs.modules.overview

ShellRoot {
    property bool enableBackground: true
    property bool enableBar: true
    property bool enableReloadPopup: false
    property bool enableScreenCorners: true
    property bool enableLock: true
    property bool enablePowermenu: true
    property bool enableLauncher: true
    property bool enableQuicksettings: true
    property bool enableNotifications: true
    property bool enableTit: true
    property bool enableOsd: true
    property bool enableOverview: true

    Component.onCompleted: {
        Idle.init();
        Gamemode.init();
    }

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
        active: enableScreenCorners & !Config.bar.floating

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
    LazyLoader {
        active: enableNotifications
        component: NotificationPopup {}
    }
    LazyLoader {
        active: enableTit
        component: Tit {}
    }
    LazyLoader {
        active: enableOsd
        component: OSD {}
    }
    LazyLoader {
        active: enableOverview
        component: Overview {}
    }
}
