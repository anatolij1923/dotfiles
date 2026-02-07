import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.services
import qs.common
import qs.widgets
import qs.config

StyledWindow {
    id: root
    name: "trayMenu"

    property int targetX
    property int targetY
    property int targetW
    property int targetH
    required property var menuHandle
    signal closeRequest

    property bool shown: false

    readonly property bool isBottom: Config.bar.bottom

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    visible: true
    WlrLayershell.layer: WlrLayer.Overlay

    function closeMenu() {
        shown = false;
    }

    Component.onCompleted: {
        shown = true;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.closeMenu()
    }

    Rectangle {
        id: menuContent
        color: Colors.palette.m3surfaceContainer
        border.color: Colors.palette.m3surfaceContainerHigh
        border.width: 1
        radius: Appearance.rounding.normal 

        width: Math.max(200, (stackView.currentItem ? stackView.currentItem.implicitWidth : 200) + 16)
        height: (stackView.currentItem ? stackView.currentItem.implicitHeight : 100) + 16

        opacity: root.shown ? 1 : 0

        Behavior on opacity {
            Anim {
                onRunningChanged: {
                    if (!running && !root.shown) {
                        root.closeRequest();
                    }
                }
            }
        }

        Behavior on height {
            Anim {
                duration: Appearance.animDuration.expressiveFastSpatial
                easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
            }
        }

        x: {
            let targetCenter = root.targetX + (root.targetW / 2);
            let pos = targetCenter - (width / 2);
            return Math.max(10, Math.min(Screen.width - width - 10, pos));
        }

        y: root.targetY

        StackView {
            id: stackView
            anchors.fill: parent
            anchors.margins: 8
            clip: true
            initialItem: rootPageComp

            pushEnter: Transition {
                NumberAnimation {
                    property: "x"
                    from: stackView.width
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            pushExit: Transition {
                NumberAnimation {
                    property: "x"
                    to: -stackView.width
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            popEnter: Transition {
                NumberAnimation {
                    property: "x"
                    from: -stackView.width
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
            popExit: Transition {
                NumberAnimation {
                    property: "x"
                    to: stackView.width
                    duration: 200
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Component {
        id: rootPageComp
        MenuPage {
            currentHandle: root.menuHandle
        }
    }

    component MenuPage: Item {
        id: page
        property var currentHandle

        implicitWidth: layout.implicitWidth
        implicitHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: stackView.depth > 1 ? 36 : 0
                visible: stackView.depth > 1
                clip: true

                StateLayer {
                    anchors.fill: parent
                    anchors.margins: 2
                    radius: 6
                    onClicked: stackView.pop()
                    StyledText {
                        anchors.centerIn: parent
                        text: "‹ Back"
                        size: 16
                        color: Colors.palette.m3onSurface
                    }
                }
            }

            QsMenuOpener {
                id: opener
                menu: page.currentHandle
            }

            Repeater {
                model: opener.children
                delegate: TrayMenuItem {
                    Layout.fillWidth: true
                    onTriggered: root.closeMenu()
                    onOpenSubmenu: handle => stackView.push(rootPageComp, {
                            "currentHandle": handle
                        })
                }
            }
        }
    }
}
