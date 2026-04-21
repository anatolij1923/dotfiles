import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.common
import qs.widgets
import qs.services

Item {
    id: root

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape)
            PolkitService.cancel();
    }

    function submit() {
        if (input.text.length > 0)
            PolkitService.submit(input.text);
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: Colors.palette.m3surface
        border.width: 1
        border.color: Colors.palette.m3surfaceContainerHigh
        radius: Appearance.rounding.xxl

        ColumnLayout {
            id: mainLayout
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: Appearance.spacing.xl
            }
            spacing: Appearance.spacing.lg

            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                MaterialSymbol {
                    icon: "key_vertical"
                    color: Colors.palette.m3primary
                    size: 32
                }

                StyledText {
                    text: "Authorization"
                    weight: 600
                    size: 24
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.rightMargin: 32
                }
            }

            StyledText {
                text: PolkitService.cleanMessage || "Root privileges are required"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: Colors.palette.m3onSurfaceVariant
                size: 18
            }

            Rectangle {
                id: passwordBox
                Layout.fillWidth: true
                implicitHeight: 60
                color: Colors.palette.m3surfaceContainerHigh
                radius: Appearance.rounding.full

                StyledTextField {
                    id: input
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 15

                    placeholderText: "Enter your password"
                    echoMode: TextInput.Password
                    inputMethodHints: Qt.ImhSensitiveData
                    focus: true

                    onAccepted: root.submit()
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Appearance.spacing.sm

                Item {
                    Layout.fillWidth: true
                }

                TextButton {
                    text: "Cancel"
                    padding: Appearance.spacing.md
                    onClicked: PolkitService.cancel()
                    textSize: 20
                }

                TextButton {
                    id: submitBtn
                    text: "Submit"
                    padding: Appearance.spacing.md

                    color: input.text.length > 0 ? Colors.palette.m3primary : Colors.palette.m3surfaceContainerHigh
                    textSize: 20

                    checked: input.text.length > 0
                    onClicked: root.submit()
                    Behavior on color {
                        CAnim {}
                    }
                }
            }
        }
    }
}
