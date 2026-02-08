import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    property string label
    property string value
    property string placeholder: ""
    property int padding: Appearance.padding.normal

    implicitHeight: Math.max(textField.implicitHeight, 40)
    Layout.fillWidth: true

    RowLayout {
        anchors.fill: parent
        spacing: Appearance.padding.normal

        // anchors.leftMargin: root.padding
        // anchors.rightMargin: root.padding

        StyledText {
            text: root.label
        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.preferredWidth: 200
            Layout.preferredHeight: 40
            radius: Appearance.rounding.normal
            color: Colors.palette.m3surfaceContainer
            border.width: 1
            border.color: textField.focus ? Colors.palette.m3primary : Colors.palette.m3outline

            Behavior on border.color {
                CAnim {}
            }

            StyledTextField {
                id: textField
                anchors.fill: parent
                text: root.value
                placeholder: root.placeholder
                fontSize: 14

                property bool updating: false

                onTextChanged: {
                    if (!updating && root.value !== text) {
                        root.value = text;
                    }
                }
            }
        }
    }

    property bool updating: false

    onValueChanged: {
        if (!updating && textField.text !== value) {
            updating = true;
            textField.text = value;
            updating = false;
        }
    }
}
