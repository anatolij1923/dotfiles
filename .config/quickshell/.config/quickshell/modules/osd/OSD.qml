import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.services
import qs.config

Scope {
    id: root
    property string currentIndicator: "volume"
    property var indicators: [
        {
            id: "volume",
            sourceUrl: "VolumeIndicator.qml"
        },
        {
            id: "brightness",
            sourceUrl: "BrightnessIndicator.qml"
        },
    ]

    function triggerOsd() {
        GlobalStates.osdOpened = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: Config.osd.timeout
        repeat: false
        running: false

        onTriggered: {
            GlobalStates.osdOpened = false;
        }
    }

    Connections {
        target: Audio.sink?.audio ?? null

        function onVolumeChanged() {
            if (!Audio.ready) {
                return;
            }
            root.currentIndicator = "volume";
            console.log("WASSUP");
            root.triggerOsd();
        }
    }

    Connections {
        target: Brightness
        function onBrightnessChanged() {
            root.currentIndicator = "brightness";
            root.triggerOsd();
        }
    }

    Connections {
        target: Audio.sink?.audio ?? null

        function onMutedChanged() {
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }

    Loader {
        id: osdLoader
        active: GlobalStates.osdOpened && !GlobalStates.screenLocked

        sourceComponent: PanelWindow {
            id: osdRoot
            color: "transparent"
            implicitWidth: columnLayout.implicitWidth
            implicitHeight: columnLayout.implicitHeight

            anchors {
                top: true
            }

            margins {
                top: Config.bar.height + Appearance.padding.huge
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "quickshell:osd"

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0

            mask: Region {
                item: content
            }

            ColumnLayout {
                id: columnLayout
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }

                Loader {
                    id: osdIndicatorLoader
                    source: root.indicators.find(i => i.id === root.currentIndicator)?.sourceUrl
                }
            }

            // Item {
            //     id: content
            //     MouseArea {
            //         anchors.fill: parent
            //         hoverEnabled: true
            //         onEntered: GlobalStates.osdVolumeOpened = false
            //     }
            //
            //     Loader {
            //         active: GlobalStates.osdOpened
            //         source: root.indicators.find(i => i.id === root.currentIndicator)?.sourceUrl
            //     }
            // }
        }
    }
}
