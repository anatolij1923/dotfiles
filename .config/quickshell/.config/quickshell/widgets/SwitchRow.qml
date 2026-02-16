import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Item {
    id: root
    property string label
    property bool value
    signal toggled(bool value)

    Layout.fillWidth: true
    implicitHeight: 48 

    StateLayer {
        anchors.fill: parent
            radius: Appearance.rounding.lg
            opacity: 0.3
            onClicked: {
                sw.toggle();
                root.toggled(sw.checked);
            }
    }
    RowLayout {
        anchors.fill: parent
        spacing: Appearance.spacing.md

        StyledText {
            text: root.label
            Layout.fillWidth: true
            color: Colors.palette.m3onSurface
        }

        StyledSwitch {
            id: sw
            checked: root.value
            onToggled: root.toggled(checked)
        }
    }
    
}
