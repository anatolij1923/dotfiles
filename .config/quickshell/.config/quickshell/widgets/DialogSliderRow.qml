pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    property string label: ""
    property real value: 0.5
    property real from: 0
    property real to: 1
    property list<real> stopIndicatorValues: [0, 0.25, 0.5, 0.75, 1]
    property string valueSuffix: ""

    implicitHeight: column.implicitHeight
    Layout.fillWidth: true
    Layout.topMargin: Appearance.padding.small
    Layout.bottomMargin: Appearance.padding.small

    ColumnLayout {
        id: column
        anchors.fill: parent
        spacing: Appearance.padding.smaller

        RowLayout {
            Layout.fillWidth: true
            StyledText { text: root.label }
            Item { Layout.fillWidth: true }
            StyledText {
                text: root.valueSuffix ? (slider.value.toFixed(2) + root.valueSuffix) : slider.value.toFixed(2)
                color: Colors.palette.m3onSurfaceVariant
                size: 14
            }
        }

        StyledSlider {
            id: slider
            value: root.value
            from: root.from
            to: root.to
            stopIndicatorValues: root.stopIndicatorValues
            configuration: StyledSlider.Configuration.M
            Layout.fillWidth: true
            onValueChanged: () => root.value = slider.value
        }
    }

    onValueChanged: () => {
        if (typeof slider !== "undefined" && Math.abs(slider.value - root.value) > 0.001)
            slider.value = root.value
    }
    Component.onCompleted: slider.value = root.value
}
