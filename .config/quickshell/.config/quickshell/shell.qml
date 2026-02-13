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
import qs.modules.session
import qs.modules.launcher
import qs.modules.notifications
import qs.modules.tit
import qs.modules.quicksettings
import qs.modules.osd
import qs.modules.overview
import qs.modules.polkit
import qs.modules.settings
import qs.modules.picker
import qs.modules.dashboard

ShellRoot {
    id: root

    Component.onCompleted: {
        Idle.init();
        Gamemode.init()
    }

    Bar {}
    ScreenCorners {}
    Quicksettings {}
    Launcher {}
    Dashboard {}
    Settings {}
    Picker {}
    Overview {}
    SessionMenu {}
    Lock {}
    NotificationPopup {}
    ActivateDotfiles {}
    Background {}
    OSD {}
    Polkit {}
}
