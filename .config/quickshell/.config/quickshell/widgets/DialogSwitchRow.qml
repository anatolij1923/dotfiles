pragma ComponentBehavior: Bound
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

    implicitHeight: row.implicitHeight
    Layout.fillWidth: true
    Layout.topMargin: Appearance.spacing.sm
    Layout.bottomMargin: Appearance.spacing.sm

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: Appearance.spacing.md

        StyledText { text: root.label }
        Item { Layout.fillWidth: true }
        StyledSwitch {
            checked: root.value
            onToggled: root.toggled(checked)
        }
    }
}
