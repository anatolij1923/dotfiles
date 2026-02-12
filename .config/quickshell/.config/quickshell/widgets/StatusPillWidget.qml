pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.common
import qs.widgets
import qs.services
import qs

Item {
    id: root
    property string text
    property string icon
    property bool quicksettingsOpened
    readonly property int padding: Appearance.spacing.sm
    default property alias content: content.data

    implicitHeight: content.implicitHeight
    implicitWidth: content.implicitWidth

    RowLayout {
        id: content
        anchors.fill: parent
        spacing: 2

        StyledText {
            text: root.text
            visible: root.text !== ""
            color: root.quicksettingsOpened ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
            Behavior on color {
                CAnim {}
            }
        }

        MaterialSymbol {
            icon: root.icon
            visible: root.icon !== ""
            size: 22
            color: root.quicksettingsOpened ? Colors.palette.m3onSecondaryContainer : Colors.palette.m3onSurface
            Behavior on color {
                CAnim {}
            }
        }
    }
}
