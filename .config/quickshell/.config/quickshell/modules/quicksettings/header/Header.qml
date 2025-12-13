import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs
import qs.services
import qs.modules.common

RowLayout {
    id: root
    Layout.fillHeight: false
    Layout.alignment: Qt.AlignTop

    Rectangle {
        implicitWidth: uptime.implicitWidth + Appearance.padding.normal * 2
        implicitHeight: uptime.implicitHeight + Appearance.padding.normal * 2

        color: Colors.palette.m3surfaceContainer
        radius: Appearance.rounding.huge

        StyledText {
            id: uptime
            text: `${Time.uptime}`
            anchors.centerIn: parent
            size: 20
        }
    }

    // ColumnLayout {
    //     StyledText {
    //         text: Quickshell.env("USER")
    //         weight: 500
    //     }
    //     StyledText {
    //         text: `Uptime ${Time.uptime}`
    //         size: 16
    //     }
    // }

    Item {
        Layout.fillWidth: true
    }

    IconButton {
        implicitWidth: 52
        implicitHeight: 52
        icon: "power_settings_new"
        radius: Appearance.rounding.large
        inactiveColor: Colors.palette.m3surface

        onClicked: {
            GlobalStates.quicksettingsOpened = false;
            GlobalStates.powerMenuOpened = true;
        }

        StyledTooltip {
            text: "Open power menu"
        }
    }
}
