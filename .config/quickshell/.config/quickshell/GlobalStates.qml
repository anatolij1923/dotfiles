pragma Singleton
pragma ComponentBehavior: Bound
import qs.modules.common
import qs
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Singleton {
    id: root

    property bool launcherOpened: false
    property bool powerMenuOpened: false
    property bool screenLocked: false
    property bool screenLockContainsCharacters: false
    property bool screenUnlockFailed: false
    property bool quicksettingsOpened: false
    property bool osdOpened: false

    property bool titOpened: false

    property bool shloonixActivated: true

    property bool idleIngibitorToggled: false
    property bool sleepTimerToggled: false
}
