import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    property string label
    property int value
    property int step: 1
    property int from: 0
    property int to: 100
    property int padding: Appearance.spacing.xs

    implicitHeight: content.implicitHeight
    Layout.fillWidth: true

    RowLayout {
        id: content
        anchors.fill: parent
        spacing: Appearance.spacing.md

        // anchors.leftMargin: root.padding
        // anchors.rightMargin: root.padding

        StyledText {
            text: root.label
        }

        Item {
            Layout.fillWidth: true
        }

        StyledSpinBox {
            id: spin
            value: root.value
            stepSize: root.step
            from: root.from
            to: root.to

            onValueChanged: root.value = value
        }
    }
}
