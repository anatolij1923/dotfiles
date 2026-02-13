import QtQuick
import QtQuick.Layouts
import qs.services
import qs.config
import qs.common
import qs.modules.bar.components
import qs.modules.bar.components.statusPill
import qs.modules.bar.components.tray


Rectangle {
    id: root

    property int sideMargins: Appearance.spacing.lg
    property int contentSpacing: Appearance.spacing.md

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    radius: Config.bar.floating ? Appearance.rounding.xl : 0

    color: transparent ? Colors.alpha(Colors.palette.m3surface, alpha) : Colors.palette.m3surface

    RowLayout {
        anchors {
            left: parent.left
            leftMargin: root.sideMargins
            top: parent.top
            bottom: parent.bottom
        }

        spacing: root.contentSpacing

        LauncherButton {}
        Workspaces {}
        AppName {}
    }

    ClockWidget {
        id: clock
        anchors {
            centerIn: parent
            top: parent.top
            bottom: parent.bottom
        }
    }

    RowLayout {
        id: rightSide

        anchors {
            right: parent.right
            rightMargin: root.sideMargins
            top: parent.top
            bottom: parent.bottom
        }

        spacing: root.contentSpacing

        RecordWidget {}
        Tray {}
        // SysButton {}
        StatusPill {}
        BatteryWidget {
            showPopup: true
        }
    }
}
