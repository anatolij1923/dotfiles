import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.widgets
import qs.common

Item {
    id: root
    required property string text
    property bool shown: false
    property real horizontalPadding: 10
    property real verticalPadding: 5
    implicitWidth: tooltipTextObject.implicitWidth + 2 * root.horizontalPadding
    implicitHeight: tooltipTextObject.implicitHeight + 2 * root.verticalPadding

    property bool isVisible: background.implicitHeight > 0

    Rectangle {
        id: background
        anchors {
            bottom: root.bottom
            horizontalCenter: root.horizontalCenter
        }

        color: Colors.palette.m3onSurface
        Behavior on color {
            CAnim {}
        }

        implicitWidth: root.shown ? (tooltipTextObject.implicitWidth + 2 * root.horizontalPadding) : 0
        implicitHeight: root.shown ? (tooltipTextObject.implicitHeight + 2 * root.verticalPadding) : 0
        clip: true
        opacity: root.shown ? 1 : 0

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
        Behavior on implicitHeight {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutCubic
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }

        border {
            width: 1
            color: Colors.palette.m3outline
        }
        radius: 16

        StyledText {
            id: tooltipTextObject
            anchors.centerIn: parent
            color: Colors.palette.m3surface
            text: root.text
            size: Appearance.font.size.small
            wrapMode: Text.Wrap
        }
    }
}
