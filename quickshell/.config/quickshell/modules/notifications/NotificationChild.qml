import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs
import qs.services
import Quickshell.Services.Notifications
import qs.modules.common
import qs.utils

// From https://github.com/caelestia-dots/shell with some modifications.
// License: GPLv3

Rectangle {
    id: root
    implicitWidth: 450
    implicitHeight: content.implicitHeight
    readonly property int nonAnimHeight: summary.implicitHeight + (root.expanded ? appName.height + body.height + actions.height + actions.anchors.topMargin : bodyPreview.height) + content.anchors.margins * 2

    // property string title: ""
    property string appIcon: ""
    property string appName: ""
    property string summary: ""
    property string body: ""
    property string image: ""
    property string time: ""
    // property var rawNotif
    // property list<var> buttons: []
    //
    required property Notifications.Notif modelData
    readonly property bool hasImage: modelData.image.length > 0
    readonly property bool hasAppIcon: modelData.appIcon.length > 0

    property bool expanded: false

    color: root.modelData.urgency === NotificationUrgency.Critical ? Colors.secondary_container : Colors.surface_container
    radius: Appearance.rounding.large

    MouseArea {
        property int startY
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.expanded && body.hoveredLink ? Qt.PointingHandCursor : pressed ? Qt.ClosedHandCursor : undefined
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        preventStealing: true

        onEntered: root.modelData.timer.stop()
        onExited: {
            if (!pressed)
                root.modelData.timer.start();
        }

        drag.target: parent
        drag.axis: Drag.XAxis

        onPressed: event => {
            root.modelData.timer.stop();
            startY = event.y;
            if (event.button === Qt.MiddleButton)
                root.modelData.close();
        }
        onReleased: event => {
            if (!containsMouse)
                root.modelData.timer.start();

            if (Math.abs(root.x) < 400 * 0.4)
                root.x = 0;
            else
                root.modelData.popup = false;
        }
        onPositionChanged: event => {
            if (pressed) {
                const diffY = event.y - startY;
                if (Math.abs(diffY) > 20)
                    root.expanded = diffY > 0;
            }
        }

        Item {
            id: content

            implicitHeight: root.nonAnimHeight
            // implicitHeight: content.childrenRect.height
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Appearance.padding.normal

            Behavior on implicitHeight {
                Anim {
                    duration: Appearance.animDuration.expressiveDefaultSpatial
                    easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                }
            }

            Loader {
                id: image

                // active: root.hasImage
                active: false
                asynchronous: true

                anchors.left: parent.left
                anchors.top: parent.top
                width: 48
                height: 48
                visible: root.hasImage || root.hasAppIcon

                sourceComponent: ClippingRectangle {
                    radius: Appearance.rounding.full
                    color: 'transparent'
                    implicitWidth: 48
                    implicitHeight: 48

                    Image {
                        anchors.fill: parent
                        source: Qt.resolvedUrl(root.modelData.image)
                        fillMode: Image.PreserveAspectCrop
                        cache: false
                        asynchronous: true
                    }
                }
            }

            Loader {
                id: appIcon

                active: root.hasAppIcon || !root.hasImage
                asynchronous: true

                anchors.horizontalCenter: root.hasImage ? undefined : image.horizontalCenter
                anchors.verticalCenter: root.hasImage ? undefined : image.verticalCenter
                anchors.right: root.hasImage ? image.right : undefined
                anchors.bottom: root.hasImage ? image.bottom : undefined

                sourceComponent: Rectangle {
                    radius: Appearance.rounding.full
                    color: root.modelData.urgency === NotificationUrgency.Critical ? Colors.error : root.modelData.urgency === NotificationUrgency.Low ? Colors.surface_container_highest : Colors.secondary_container
                    implicitWidth: 48
                    implicitHeight: 48

                    Loader {
                        id: icon

                        active: root.hasAppIcon
                        asynchronous: true

                        anchors.centerIn: parent

                        width: Math.round(parent.width * 0.6)
                        height: Math.round(parent.width * 0.6)

                        sourceComponent: IconImage {
                            anchors.fill: parent
                            source: Quickshell.iconPath(root.modelData.appIcon)
                            // color: root.modelData.urgency === NotificationUrgency.Critical ? Colours.palette.m3onError : root.modelData.urgency === NotificationUrgency.Low ? Colours.palette.m3onSurface : Colours.palette.m3onSecondaryContainer
                            layer.enabled: root.modelData.appIcon.endsWith("symbolic")
                        }
                    }

                    Loader {
                        active: !root.hasAppIcon
                        asynchronous: true
                        anchors.centerIn: parent
                        // anchors.horizontalCenterOffset: -Appearance.font.size.large * 0.02
                        // anchors.verticalCenterOffset: Appearance.font.size.large * 0.02

                        sourceComponent: MaterialSymbol {
                            icon: Icons.getNotifIcon(root.modelData.summary, root.modelData.urgency)

                            color: root.modelData.urgency === NotificationUrgency.Critical ? Colors.on_error : root.modelData.urgency === NotificationUrgency.Low ? Colors.on_surface : Colors.on_secondary_container
                            // font.pointSize: Appearance.font.size.large
                        }
                    }
                }
            }

            StyledText {
                id: appName

                text: root.modelData.appName || "Unknown"
                anchors.top: parent.top
                anchors.left: image.right
                anchors.leftMargin: Appearance.padding.normal
                color: Qt.alpha(Colors.on_surface, 0.7)

                animate: true
                opacity: root.expanded ? 1 : 0
                Behavior on opacity {
                    Anim {}
                }
            }

            StyledText {
                id: summary
                anchors.top: parent.top
                anchors.left: image.right
                anchors.leftMargin: Appearance.padding.normal

                animate: true
                text: summaryMetrics.elidedText

                states: State {
                    name: "expanded"
                    when: root.expanded

                    PropertyChanges {
                        summary.maximumLineCount: undefined
                    }

                    AnchorChanges {
                        target: summary
                        anchors.top: appName.bottom
                    }
                }
                transitions: Transition {
                    PropertyAction {
                        target: summary
                        property: "maximumLineCount"
                    }
                    AnchorAnimation {
                        duration: Appearance.animDuration.normal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.animCurves.standard
                    }
                }
            }

            TextMetrics {
                id: summaryMetrics

                text: root.modelData.summary
                font.family: summary.font.family
                font.pointSize: summary.font.pointSize
                elide: Text.ElideRight
                elideWidth: expandButton.x - time.width - timeSep.width - summary.x - Appearance.padding.small * 3
            }

            StyledText {
                id: timeSep
                text: "•"
                anchors.top: parent.top
                anchors.left: summary.right
                anchors.leftMargin: Appearance.padding.small
                color: Qt.alpha(Colors.on_surface, 0.7)

                states: State {
                    name: "expanded"
                    when: root.expanded

                    AnchorChanges {
                        target: timeSep
                        anchors.left: appName.right
                    }
                }
                transitions: Transition {
                    PropertyAction {
                        target: summary
                        property: "maximumLineCount"
                    }
                    AnchorAnimation {
                        duration: Appearance.animDuration.normal
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: Appearance.animCurves.standard
                    }
                }
            }

            StyledText {
                id: time
                text: root.modelData.timeStr
                anchors.top: parent.top
                anchors.left: timeSep.right
                anchors.leftMargin: Appearance.padding.small
                color: Qt.alpha(Colors.on_surface, 0.7)
            }

            IconButton {
                id: expandButton
                icon: root.expanded ? "keyboard_arrow_down" : "keyboard_arrow_up"
                anchors.right: parent.right
                anchors.top: parent.top
                implicitHeight: time.implicitHeight + Appearance.padding.normal

                color: root.modelData.urgency === NotificationUrgency.Critical ? Colors.secondary_container : Colors.surface_container

                onClicked: root.expanded = !root.expanded
            }

            StyledText {
                id: bodyPreview
                text: root.modelData.body
                anchors.left: summary.left
                anchors.right: expandButton.left
                anchors.top: summary.bottom
                anchors.rightMargin: Appearance.padding.normal
                color: Qt.alpha(Colors.on_surface, 0.7)
                wrapMode: Text.Wrap
                maximumLineCount: 1
                elide: Text.ElideRight
                visible: !root.expanded
                opacity: root.expanded ? 0 : 1
                Behavior on opacity {
                    Anim {}
                }
            }

            StyledText {
                id: body
                text: root.modelData.body
                anchors.left: summary.left
                anchors.right: expandButton.left
                anchors.top: summary.bottom
                anchors.rightMargin: Appearance.padding.normal
                color: Qt.alpha(Colors.on_surface, 0.7)
                wrapMode: Text.Wrap
                visible: root.expanded
                opacity: root.expanded ? 1 : 0
                Behavior on opacity {
                    Anim {}
                }
            }

            RowLayout {
                id: actions
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: body.bottom
                anchors.topMargin: Appearance.padding.small
                opacity: root.expanded ? 1 : 0

                Behavior on opacity {
                    Anim {
                        duration: Appearance.animDuration.expressiveDefaultSpatial
                        easing.bezierCurve: Appearance.animCurves.expressiveDefaultSpatial
                    }
                }

                IconButton {
                    icon: "close"
                    inactiveColor: Colors.surface_container_high
                    onClicked: root.modelData.close()
                    padding: Appearance.padding.smaller
                }

                Repeater {

                    model: root.modelData.actions

                    delegate: TextButton {
                        text: modelData.text
                        inactiveColor: Colors.surface_container_high
                        padding: Appearance.padding.smaller
                        onClicked: () => {
                            modelData.invoke();
                        }
                    }
                }
            }
        }
    }
}
