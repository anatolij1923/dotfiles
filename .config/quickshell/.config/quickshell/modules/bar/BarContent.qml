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

        spacing: Appearance.padding.normal

        // LogoWidget {}
        Workspaces {}
        AppName {}
    }

    UsageInfo {
        anchors {
            right: clock.left
            rightMargin: Appearance.padding.smaller
            verticalCenter: parent.verticalCenter
        }
    }
    //
    ClockWidget {
        id: clock
        anchors {
            centerIn: parent
            top: parent.top
            bottom: parent.bottom
        }
    }
    //
    WeatherWidget {
        id: weather
        anchors {
            left: clock.right
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

        spacing: Appearance.padding.normal

        RecordWidget {}
        Tray {}
        SysButton {}
        Loader {
            active: Battery.available
            sourceComponent: BatteryWidget {
                showPopup: true
            }
        }
    }
}
