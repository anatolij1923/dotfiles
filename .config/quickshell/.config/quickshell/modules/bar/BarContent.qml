import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.config

Rectangle {
    id: root
    anchors.fill: parent

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    radius: Config.bar.floating ? Appearance.rounding.large : 0

    color: transparent ? Qt.alpha(Colors.palette.m3surface, alpha) : Colors.palette.m3surface

    Workspaces {
        anchors.centerIn: parent
    }

    RowLayout {
        id: rightSide

        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            rightMargin: 32
        }

        spacing: Appearance.padding.large

        Tray {}
        QsButton {}
        BatteryWidget {}
        ClockWidget {}
    }

    // QsButton {
    //     id: qsButton
    //     anchors {
    //         verticalCenter: parent.verticalCenter
    //         right: clock.left
    //     }
    // }
    //
    // ClockWidget {
    //     id: clock
    //     anchors {
    //         right: parent.right
    //         verticalCenter: parent.verticalCenter
    //         rightMargin: 32
    //     }
    // }
}
