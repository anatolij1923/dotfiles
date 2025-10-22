import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.services
import qs.modules.common

Item {
    id: root
    implicitWidth: 420
    implicitHeight: columnLayout.implicitHeight + 20

    property string title: ""
    property string body: ""
    property string image: ""
    property var rawNotif
    property list<var> buttons: []
    property int animDuration: 220

    opacity: 0
    scale: 0.98
    visible: true

    // плавное появление
    Component.onCompleted: enterAnim.running = true

    ParallelAnimation {
        id: enterAnim
        running: false
        PropertyAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: root.animDuration; easing.type: Easing.OutCubic }
        PropertyAnimation { target: root; property: "scale"; from: 0.98; to: 1.0; duration: root.animDuration; easing.type: Easing.OutBack }
    }

    function closeSmooth() {
        exitAnim.running = true
    }

    ParallelAnimation {
        id: exitAnim
        running: false
        PropertyAnimation { target: root; property: "opacity"; from: 1; to: 0; duration: root.animDuration; easing.type: Easing.InCubic }
        PropertyAnimation { target: root; property: "scale"; from: 1.0; to: 0.97; duration: root.animDuration; easing.type: Easing.InCubic }
        onStopped: root.visible = false
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Appearance.rounding.large
        color: Colors.surface_container
        border.color: Colors.outline_variant
        border.width: 1
    }

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            spacing: 10
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            Image {
                id: icon
                source: root.image
                width: 32
                height: 32
                fillMode: Image.PreserveAspectFit
                visible: source !== ""
            }

            StyledText {
                id: titleText
                text: root.title
                font.bold: true
                font.pixelSize: 16
                color: Colors.on_surface
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }

        StyledText {
            id: bodyText
            text: root.body
            font.pixelSize: 14
            color: Colors.on_surface_variant
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Flow {
            id: buttonRow
            spacing: 6
            Layout.alignment: Qt.AlignHCenter

            Repeater {
                model: root.buttons
                delegate: Button {
                    text: modelData.label
                    onClicked: modelData.onClick()
                    implicitWidth: Math.max(80, contentWidth + 20)
                }
            }

            Button {
                text: "Close"
                onClicked: root.closeSmooth()
                implicitWidth: 80
            }
        }
    }
}
