import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.config
import qs.services
import qs.modules.notifications
import qs.common
import qs.widgets
import qs.modules.quicksettings.toggles
import qs.modules.quicksettings.header
import qs.modules.quicksettings.sliders
import qs.modules.quicksettings.notificationsList
import qs.modules.quicksettings.media

import Quickshell.Bluetooth

Item {
    id: root
    property int padding: 16

    property real alpha: Config.appearance.transparency.alpha
    property bool transparent: Config.appearance.transparency.enabled

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    // StyledShadow {
    //     target: root
    //     radius: background.radius
    // }

    ClippingRectangle {
        id: background
        anchors.fill: parent
        radius: Appearance.rounding.hugeass
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
            Header {}
            Toggles {
                id: toggles
                onOpenMicDialogRequested: () => micDialog.open()
            }
            Sliders {}
            // MediaPlayer {}
            NotificationsList {}
        }

        M3Dialog {
            id: micDialog
            anchors.fill: parent
            visible: false
            title: Translation.tr("quicksettings.dialogs.mic.title")

            DialogDivider {}
            DialogSwitchRow {
                label: Translation.tr("quicksettings.dialogs.mic.input_volume")
                checked: Audio.source.audio.muted
                onToggled: (v) => Audio.source.audio.muted = !v
            }
            DialogDivider {}
            DialogSliderRow {
                label: Translation.tr("quicksettings.dialogs.mic.input_volume")
                value: 0.7
                stopIndicatorValues: [0, 0.25, 0.5, 0.75, 1]
                onValueChanged: () => { /* placeholder */ }
            }
        }
    }
}
