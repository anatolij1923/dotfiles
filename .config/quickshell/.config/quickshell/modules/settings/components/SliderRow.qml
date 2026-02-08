import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    property string label
    property real value
    property real from: 0
    property real to: 100
    property int step: 1
    property string suffix: ""
    property int padding: Appearance.padding.smaller
    property alias tooltipContent: slider.tooltipContent

    // implicitHeight: Math.max(slider.implicitHeight, 40) + padding * 2
    implicitHeight: content.implicitHeight
    Layout.fillWidth: true

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: Appearance.padding.smaller

        // anchors.leftMargin: root.padding
        // anchors.rightMargin: root.padding

        RowLayout {
            Layout.fillWidth: true

            StyledText {
                text: root.label
                size: Appearance.font.size.normal
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: {
                    if (root.step >= 100) {
                        return Math.round(root.value * 100) + root.suffix;
                    } else if (root.step > 1) {
                        return Math.round(root.value * root.step) + root.suffix;
                    } else {
                        return root.value.toFixed(2) + root.suffix;
                    }
                }
                color: Colors.palette.m3onSurfaceVariant
                size: Appearance.font.size.tiny
            }
        }

        StyledSlider {
            id: slider
            value: root.value
            from: root.from
            to: root.to
            configuration: StyledSlider.Configuration.M

            property bool updating: false

            onValueChanged: {
                if (!updating && Math.abs(root.value - value) > 0.001) {
                    root.value = value;
                }
            }
        }
    }

    property bool updating: false

    onValueChanged: {
        if (!updating && Math.abs(slider.value - value) > 0.001) {
            updating = true;
            slider.value = value;
            updating = false;
        }
    }
}
