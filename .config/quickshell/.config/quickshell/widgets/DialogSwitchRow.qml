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
    Layout.topMargin: Appearance.padding.small
    Layout.bottomMargin: Appearance.padding.small

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: Appearance.padding.normal

        StyledText { text: root.label }
        Item { Layout.fillWidth: true }
        StyledSwitch {
            checked: root.value
            onToggled: root.toggled(checked)
        }
    }
}
