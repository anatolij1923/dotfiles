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
import qs.modules.polkit
import qs.modules.settings
import qs.modules.screenshot

ShellRoot {
    id: root
    property bool enableBackground: true
    property bool enableBar: true
    property bool enableReloadPopup: false
    property bool enableScreenCorners: true
    property bool enableLock: true
    property bool enablePowermenu: true
    property bool enableLauncher: true
    property bool enableQuicksettings: true
    property bool enableNotifications: true
    property bool enableTit: false
    property bool enableOsd: true
    property bool enableOverview: true
    property bool enablePolkit: true
    property bool enableSettings: true
    property bool enableScreenshot: true

    Component.onCompleted: {
        Idle.init();
    }

    LazyLoader {
        active: root.enableBackground
        component: Background {}
    }
    LazyLoader {
        active: root.enableBar
        component: Bar {}
    }
    LazyLoader {
        active: root.enableReloadPopup

        component: ReloadPopup {}
    }

    LazyLoader {
        active: root.enableScreenCorners && !Config.bar.floating

        component: ScreenCorners {}
    }

    LazyLoader {
        active: root.enableLock

        component: Lock {}
    }
    LazyLoader {
        active: root.enablePowermenu
        component: Powermenu {}
    }
    LazyLoader {
        active: root.enableLauncher
        component: Launcher {}
    }
    LazyLoader {
        active: root.enableQuicksettings
        component: Quicksettings {}
    }
    LazyLoader {
        active: root.enableNotifications
        component: NotificationPopup {}
    }
    LazyLoader {
        active: root.enableTit
        component: Tit {}
    }
    LazyLoader {
        active: root.enableOsd
        component: OSD {}
    }
    LazyLoader {
        active: root.enableOverview
        component: Overview {}
    }

    LazyLoader {
        active: root.enablePolkit
        component: Polkit {}
    }

    LazyLoader {
        active: root.enableSettings
        component: Settings {}
    }

    LazyLoader {
        active: root.enableScreenshot
        component: ScreenshotManager {}
    }

    LazyLoader {
        active: !Config.background.dotfilesActivated
        component: ActivateDotfiles {}
    }
}
