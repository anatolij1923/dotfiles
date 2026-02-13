// ButtonGroup.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    property var model: []
    property string currentValue: ""
    property bool wrap: false
    property color inactiveColor: Colors.palette.m3surfaceContainer

    signal selected(string value, string text)

    implicitWidth: wrap ? flowLayout.width : rowLayout.implicitWidth
    implicitHeight: wrap ? flowLayout.height : rowLayout.implicitHeight
    Layout.fillWidth: true

    Row {
        id: rowLayout
        visible: !root.wrap
        spacing: 1
        Repeater {
            model: root.wrap ? [] : root.model
            delegate: buttonDelegate
        }
    }

    Flow {
        id: flowLayout
        visible: root.wrap
        width: parent.width
        spacing: 1
        Repeater {
            model: root.wrap ? root.model : []
            delegate: buttonDelegate
        }
    }

    Component {
        id: buttonDelegate
        TextIconButton {
            readonly property var item: modelData
            readonly property bool isChecked: root.currentValue === item.value
            readonly property bool isFirst: index === 0
            readonly property bool isLast: index === (root.model.length - 1)

            text: item.text || ""
            icon: item.icon || ""
            checked: isChecked
            inactiveColor: root.inactiveColor

            radius: isChecked ? Appearance.rounding.xl : Appearance.rounding.sm
            topLeftRadius: (isFirst || isChecked) ? Appearance.rounding.xl : Appearance.rounding.sm
            bottomLeftRadius: (isFirst || isChecked) ? Appearance.rounding.xl : Appearance.rounding.sm
            topRightRadius: (isLast || isChecked) ? Appearance.rounding.xl : Appearance.rounding.sm
            bottomRightRadius: (isLast || isChecked) ? Appearance.rounding.xl : Appearance.rounding.sm

            verticalPadding: Appearance.spacing.sm
            horizontalPadding: Appearance.spacing.xl
            onClicked: root.selected(item.value, item.text)
        }
    }
}
