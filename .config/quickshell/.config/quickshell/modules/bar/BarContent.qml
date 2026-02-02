import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.config
import qs.common
import qs.widgets

Rectangle {
    id: root
    anchors.fill: parent

    property int sideMargins: Appearance.padding.huge
    property int contentSpacing: Appearance.padding.large

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    radius: Config.bar.floating ? Appearance.rounding.large : 0

    color: transparent ? Qt.alpha(Colors.palette.m3surface, alpha) : Colors.palette.m3surface

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

    Media {
        anchors {
            right: usageInfo.left
            verticalCenter: parent.verticalCenter
            rightMargin: Appearance.padding.smaller
        }
    }

    UsageInfo {
        id: usageInfo
        anchors {
            right: clock.left
            rightMargin: Appearance.padding.smaller
            verticalCenter: parent.verticalCenter
        }
    }

    ClockWidget {
        id: clock
        anchors {
            centerIn: parent
            top: parent.top
            bottom: parent.bottom
        }
    }

    WeatherWidget {
        id: weather
        anchors {
            left: clock.right
            leftMargin: Appearance.padding.smaller
            verticalCenter: parent.verticalCenter
        }
    }

    Tools {
        id: tools
        anchors {
            left: weather.right
            leftMargin: Appearance.padding.smaller
            verticalCenter: parent.verticalCenter
        }
    }

    RowLayout {
        id: rightSide

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            rightMargin: root.sideMargins
        }

        spacing: root.contentSpacing

        RecordWidget {}
        Tray {}
        SysButton {}
        BatteryWidget {
            showPopup: true
        }
    }
}
