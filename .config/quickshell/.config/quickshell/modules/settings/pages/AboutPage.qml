import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import qs.modules.settings
import qs.config
import qs.common
import qs.widgets
import qs.services

ContentPage {
    title: Translation.tr("settings.about.title")

    ContentItem {
        title: Translation.tr("settings.about.shell_name")

        Item {
            Layout.fillWidth: true
            implicitHeight: 550

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Appearance.spacing.xl

                Image {
                    id: mrSex
                    source: `${Quickshell.shellDir}/assets/mrSex.png`

                    property int clickCount: 0

                    sourceSize {
                        width: 400
                        height: 550
                    }

                    SequentialAnimation on rotation {
                        id: idleRotation
                        loops: Animation.Infinite
                        running: !crazyRotation.running

                        Anim {
                            from: -4
                            to: 4
                            duration: 2000
                            easing.bezierCurve: Appearance.animCurves.expressiveEffects
                        }
                        Anim {
                            from: 4
                            to: -4
                            duration: 2000
                            easing.bezierCurve: Appearance.animCurves.expressiveEffects
                        }
                    }

                    Anim {
                        id: crazyRotation
                        target: mrSex
                        property: "rotation"
                        from: 0
                        to: 3600
                        duration: 1800
                        easing.bezierCurve: Appearance.animCurves.expressiveEffects

                        onStopped: {
                            mrSex.rotation = 0;
                            mrSex.clickCount = 0;
                            if (Config.system.dotfilesActivated === true) {
                                Config.system.dotfilesActivated = false;
                                Logger.e("ACTIVATION", "Dotfiles deactivated")
                            }
                        }
                    }

                    Behavior on scale {
                        Anim {
                            duration: Appearance.animDuration.expressiveFastSpatial
                            easing.bezierCurve: Appearance.animCurves.expressiveFastSpatial
                        }
                    }

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1
                        colorizationColor: Colors.palette.m3secondary
                    }

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            mrSex.scale = 1.2;
                            resetScaleTimer.start();

                            // Логика пасхалки
                            mrSex.clickCount++;
                            if (mrSex.clickCount >= 3) {
                                crazyRotation.start();
                            }
                        }

                        Timer {
                            id: resetScaleTimer
                            interval: 200
                            onTriggered: mrSex.scale = 1.0
                        }
                    }

                    StyledTooltip {
                        extraVisibleCondition: ma.containsMouse
                        text: mrSex.clickCount > 0 ? Translation.tr("settings.about.stop_it") : "Mr. Sex"
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter

                    TextIconButton {
                        id: btn
                        verticalPadding: Appearance.spacing.md
                        horizontalPadding: Appearance.spacing.xl
                        inactiveColor: Colors.palette.m3surfaceContainerHigh
                        icon: "commit"
                        text: Translation.tr("settings.about.open_repo")

                        Elevation {
                            anchors.fill: parent
                            opacity: 0.7
                            radius: parent.radius
                            z: -1
                            level: btn.stateLayer.containsMouse ? 4 : 2
                        }

                        onClicked: {
                            Quickshell.execDetached(["xdg-open", "https://github.com/anatolij1923/dotfiles"]);
                        }

                        StyledTooltip {
                            text: Translation.tr("settings.about.open_repo_tooltip")
                        }
                    }
                }
            }
        }

        SwitchRow {
            label: Translation.tr("settings.about.activate_dotfiles")
            value: Config.system.dotfilesActivated
            onToggled: Config.system.dotfilesActivated = value
        }
    }
}
