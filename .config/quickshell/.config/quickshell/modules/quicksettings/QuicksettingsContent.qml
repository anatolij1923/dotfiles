import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.config
import qs.services
import qs.modules.notifications
import qs.modules.common
import qs.modules.quicksettings.toggles
import qs.modules.quicksettings.header
import qs.modules.quicksettings.sliders
import qs.modules.quicksettings.notificationsList

import Quickshell.Bluetooth

Item {
    id: root
    property int padding: 16

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 24
        color: root.transparent ? Qt.alpha(Colors.palette.m3surface, root.alpha) : Colors.palette.m3surface
        clip: true
        Behavior on color {
            CAnim {}
        }
        // implicitWidth: 500

        border.width: 1
        border.color: Colors.palette.m3surfaceContainerHigh

        Behavior on border.color {
            CAnim {}
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: root.padding
            spacing: Appearance.padding.normal
            Layout.fillHeight: true
            // Header
            Header {}

            Toggles {}
            Sliders {}
            NotificationsList {}
        }
    }
}
