pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.widgets
import qs.services
import qs.config

Item {
    id: root

    required property string expression
    property bool transparent: Config.appearance.transparency.enabled
    property real alpha: Config.appearance.transparency.alpha

    function activate() {
        if (result && result !== "..." && result !== "Invalid expression" && result.trim() !== "") {
            Quickshell.execDetached(["wl-copy", String(result)]);
            return true;
        }
        return false;
    }

    implicitHeight: Math.max(Config.launcher.sizes.itemHeight, (row ? (row.implicitHeight || 0) : 0) + Appearance.padding.large * 2)

    property string result

    onExpressionChanged: {
        const trimmed = expression.trim();
        if (trimmed.length > 0) {
            calcDelay.restart();
        } else {
            root.result = "";
        }
    }

    Timer {
        id: calcDelay
        interval: 70
        onTriggered: {
            calculateProc.calculate(expression.trim());
        }
    }

    Process {
        id: calculateProc
        property list<string> calcCommand: ["qalc", "-t"]

        function calculate(expression) {
            calculateProc.running = false;
            calculateProc.command = calcCommand.concat(expression);
            calculateProc.running = true;
        }

        stdout: SplitParser {
            onRead: data => {
                Logger.i("CALC", data);
                root.result = data;
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: Appearance.rounding.xl
        color: root.transparent ? Qt.alpha(Colors.palette.m3surfaceContainer, root.alpha) : Colors.palette.m3surfaceContainer
        // border.width: 1
        // border.color: Colors.palette.m3surfaceContainerHigh

        Row {
            id: row
            spacing: Appearance.padding.large
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: Appearance.padding.huge
                rightMargin: Appearance.padding.huge
            }

            property real columnWidth: (width - spacing) / 2

            StyledText {
                width: row.columnWidth
                text: root.result
                color: Colors.palette.m3onSurface
                weight: 600
                size: 22
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignLeft
            }

            // StyledText {
            //     width: row.columnWidth
            //     text: result.ok ? result.message : result.message
            //     color: result.ok ? Colors.palette.m3onSurfaceVariant : Colors.palette.m3error
            //     weight: 600
            //     size: 22
            //     elide: Text.ElideRight
            //     horizontalAlignment: Text.AlignRight
            // }
        }
    }
}
