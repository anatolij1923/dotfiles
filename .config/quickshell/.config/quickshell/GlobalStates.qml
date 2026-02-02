pragma Singleton
pragma ComponentBehavior: Bound
import qs.common
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
    property bool screenUnlocking: false
    property bool quicksettingsOpened: false
    property bool osdOpened: false
    property bool overviewOpened: false
    property bool settingsOpened: false
    property bool screenshotOpened: false

    property bool titOpened: false

    property bool idleIngibitorToggled: false
    property bool sleepTimerToggled: false
}
