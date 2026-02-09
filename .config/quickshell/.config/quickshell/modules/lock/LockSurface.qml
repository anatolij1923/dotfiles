pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.config
import qs.modules.lock
import qs.common
import qs.widgets
import qs.services
import qs.modules.bar

WlSessionLockSurface {
    id: root
    required property LockContext context

    property bool ready: false
    readonly property bool showContent: ready && !GlobalStates.screenUnlocking
    readonly property real entryOffset: 30

    color: "transparent"

    Item {
        id: mainCanvas
        anchors.fill: parent

        // dim
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: root.showContent ? Config.lock.dimOpacity : 0
            Behavior on opacity {
                Anim {
                    duration: Appearance.animDuration.large
                }
            }
        }

        // content
        Item {
            id: contentGroup
            anchors.fill: parent
            opacity: root.showContent ? 1 : 0
            scale: root.showContent ? 1.0 : 1.1

            Behavior on opacity {
                Anim {
                    duration: Appearance.animDuration.large
                }
            }
            Behavior on scale {
                Anim {
                    duration: Appearance.animDuration.large
                    easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                }
            }

            // lock icon
            ColumnLayout {
                id: lockIcon
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    topMargin: root.showContent ? 64 : 64 - entryOffset
                }
                spacing: 12
                opacity: root.showContent ? 0.85 : 0

                Behavior on anchors.topMargin {
                    Anim {
                        duration: Appearance.animDuration.large
                        easing.bezierCurve: Appearance.animCurves.emphasizedDecel
                    }
                }
                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.large
                    }
                }

                MaterialSymbol {
                    icon: "lock"
                    color: Colors.isDarkMode ? Colors.palette.m3onSurface : Colors.palette.m3surface
                    size: 32
                    Layout.alignment: Qt.AlignHCenter
                }

                StyledText {
                    text: Translation.tr("lock.locked")
                    size: 20
                    color: Colors.isDarkMode ? Colors.palette.m3onSurface : Colors.palette.m3surface
                }
            }

            // clock
            ColumnLayout {
                id: clock
                anchors {
                    top: parent.top
                    horizontalCenter: parent.horizontalCenter
                    topMargin: root.showContent ? 180 : 180
                }
                opacity: root.showContent ? 1 : 0
                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.large
                    }
                }

                StyledText {
                    Layout.alignment: Qt.AlignCenter
                    text: Time.format(Config.time.format)
                    size: 128
                    weight: 600
                    color: Colors.isDarkMode ? Colors.palette.m3onSurface : Colors.palette.m3surface
                }
                StyledText {
                    Layout.alignment: Qt.AlignCenter
                    text: Time.format("dddd dd MMMM")
                    size: 24
                    weight: 600
                    color: Colors.isDarkMode ? Colors.palette.m3onSurface : Colors.palette.m3surface
                    opacity: 0.7
                }
            }

            // tools
            RowLayout {
                id: bottomControls
                spacing: 16
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: root.showContent ? 40 : 40 - entryOffset
                }
                opacity: root.showContent ? 1 : 0

                Behavior on anchors.bottomMargin {
                    Anim {
                        duration: Appearance.animDuration.large
                        easing.bezierCurve: Appearance.animCurves.emphasizedDecel
                    }
                }
                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.large
                    }
                }

                Rectangle {
                    color: Colors.palette.m3surfaceContainer
                    radius: Appearance.rounding.full
                    implicitWidth: kbLayout.implicitWidth + 32
                    implicitHeight: 56
                    KbLayout {
                        id: kbLayout
                        anchors.centerIn: parent
                        showIcon: true
                    }
                }

                Rectangle {
                    id: passwordBoxContainer
                    implicitWidth: 320
                    implicitHeight: 56
                    radius: Appearance.rounding.full
                    color: Colors.palette.m3surfaceContainer

                    property real shakeX: 0
                    transform: Translate {
                        x: passwordBoxContainer.shakeX
                    }

                    MaterialSymbol {
                        id: icon
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: Appearance.spacing.xl
                        }

                        icon: "person"

                        color: Colors.palette.m3onSurface
                    }

                    StyledTextField {
                        id: passwordBox
                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            right: parent.bottom
                            left: icon.right
                        }
                        focus: true
                        echoMode: TextInput.Password
                        leftPadding: Appearance.spacing.md

                        placeholder: root.context.showFailure ? "Wrong password" : Quickshell.env("USER")
                        placeholderTextColor: root.context.showFailure ? Colors.palette.m3error : Colors.palette.m3onSurfaceVariant

                        onTextChanged: root.context.currentText = text
                        onAccepted: root.context.tryUnlock()

                        Connections {
                            target: root.context
                            function onCurrentTextChanged() {
                                passwordBox.text = root.context.currentText;
                            }
                            function onShowFailureChanged() {
                                if (root.context.showFailure) {
                                    shakeAnimation.start();
                                    passwordBox.text = "";
                                }
                            }
                        }
                    }

                    SequentialAnimation {
                        id: shakeAnimation
                        NumberAnimation {
                            target: passwordBoxContainer
                            property: "shakeX"
                            from: 0
                            to: 15
                            duration: 50
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            target: passwordBoxContainer
                            property: "shakeX"
                            from: 15
                            to: -15
                            duration: 50
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: passwordBoxContainer
                            property: "shakeX"
                            from: -15
                            to: 10
                            duration: 50
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: passwordBoxContainer
                            property: "shakeX"
                            from: 10
                            to: 0
                            duration: 50
                            easing.type: Easing.InQuad
                        }
                    }
                }

                Rectangle {
                    id: tools
                    implicitHeight: 56
                    implicitWidth: toolsRow.implicitWidth + 24
                    color: Colors.palette.m3surfaceContainer
                    radius: Appearance.rounding.full

                    RowLayout {
                        id: toolsRow
                        anchors.centerIn: parent
                        spacing: 8

                        IconButton {
                            radius: Appearance.rounding.full
                            icon: "bedtime"
                            iconSize: 24
                            onClicked: Session.suspend()
                        }
                        IconButton {
                            radius: Appearance.rounding.full
                            icon: "power_settings_new"
                            iconSize: 24
                            onClicked: Session.poweroff()
                        }
                        BatteryWidget {
                            showPopup: false
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: readyTimer.start()
    Timer {
        id: readyTimer
        interval: 50
        onTriggered: root.ready = true
    }
}
