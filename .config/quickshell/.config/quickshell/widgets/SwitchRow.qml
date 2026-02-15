import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.settings
import qs.common
import qs.widgets
import qs.services
import qs.config

Item {
    id: root

    property string label
    property bool value
    signal toggled(bool value)
    Layout.fillWidth: true

    property int padding: Appearance.spacing.xs

    implicitHeight: content.implicitHeight + padding * 2

    // StateLayer {
    //     anchors.fill: parent
    //
    //     radius: Appearance.rounding.lg
    //
    //     onClicked: {
    //         sw.checked = !sw.checked;
    //         root.toggled(sw.checked);
    //     }
    // }

    RowLayout {
        id: content
        anchors {
            fill: parent
            // leftMargin: root.padding
            // rightMargin: root.padding
        }
        spacing: Appearance.spacing.md

        StyledText {
            text: root.label
        }

        Item {
            Layout.fillWidth: true
        }

        StyledSwitch {
            id: sw
            checked: root.value
            onToggled: root.toggled(checked)
        }
    }
}
