pragma Singleton

import Quickshell
import Quickshell.Wayland
import QtQuick
import qs

Singleton {
    id: root

    // property bool toggled: GlobalStates.idleIngibitorToggled
    property alias enabled: props.enabled
    PersistentProperties {
        id: props

        property bool enabled
        reloadableId: "idleInhibitor"
    }

    function toggle() {
        props.enabled = !props.enabled
    }

    IdleInhibitor {
        id: idleInhibitor
        enabled: props.enabled
        window: PanelWindow {
            color: "transparent"
            mask: Region {
                item: null
            }
        }
    }
}
