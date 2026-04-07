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
import qs.modules.bar.components
import qs.modules.bar
import qs.modules.bar.components.statusPill.components

import qs.modules.lock.components

WlSessionLockSurface {
    id: root
    required property LockContext context

    property bool ready: false
    readonly property bool showContent: ready && !GlobalStates.screenUnlocking

    color: "transparent"

    Item {
        id: content
        anchors.fill: parent

        opacity: root.showContent ? 1 : 0
        scale: root.showContent ? 1.0 : 1.1

        Behavior on opacity {
            Anim {
                duration: Appearance.animDuration.lg
            }
        }
        Behavior on scale {
            Anim {
                duration: Appearance.animDuration.md
                easing.bezierCurve: Appearance.animCurves.expressiveEffects
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: root.showContent ? Config.lock.dimOpacity : 0
            Behavior on opacity {
                Anim {
                    duration: Appearance.animDuration.lg
                }
            }
        }

        Clock {
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: 180
            }
        }

        RowLayout {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 60
            }

            KbLayout {}

            PasswordField {
                context: root.context
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
