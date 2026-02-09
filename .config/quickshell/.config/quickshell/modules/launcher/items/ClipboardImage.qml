import QtQuick
import Quickshell
import Quickshell.Io
import qs.common
import qs.widgets
import qs.services

Rectangle {
    id: root
    property string entry
    property real maxWidth
    property real maxHeight: 150

    readonly property string cacheDir: "/tmp/quickshell-clip-cache"
    property string source: ""

    property int entryNumber: {
        if (!entry)
            return 0;
        const match = entry.match(/^(\d+)\t/);
        return match ? parseInt(match[1]) : 0;
    }

    property int imgWidth: {
        const match = entry.match(/(\d+)x(\d+)/);
        return match ? parseInt(match[1]) : 100;
    }
    property int imgHeight: {
        const match = entry.match(/(\d+)x(\d+)/);
        return match ? parseInt(match[2]) : 100;
    }

    property real scale: Math.min(maxWidth / imgWidth, maxHeight / imgHeight, 1)

    color: "transparent"
    radius: Appearance.rounding.md
    implicitWidth: imgWidth * scale
    implicitHeight: imgHeight * scale

    readonly property bool isImage: entry && entry.match(/\[\[.*binary data.*\]\]/)

    readonly property string filePath: `${cacheDir}/${entryNumber}.png`

    Component.onCompleted: {
        if (root.isImage && entryNumber > 0) {
            Quickshell.execDetached(["mkdir", "-p", cacheDir]);
            decodeProcess.running = true;
        }
    }

    Process {
        id: decodeProcess
        command: ["bash", "-c", `[ -f '${filePath}' ] || cliphist decode ${entryNumber} > '${filePath}'`]

        onExited: exitCode => {
            if (exitCode === 0) {
                root.source = "file://" + filePath;
            }
        }
    }

    Image {
        id: image
        anchors.fill: parent
        source: root.source
        fillMode: Image.PreserveAspectFit
        asynchronous: true
        opacity: status === Image.Ready ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Colors.palette.m3surfaceVariant
            visible: image.status !== Image.Ready
            radius: root.radius
            MaterialSymbol {
                icon: "image"
                anchors.centerIn: parent
                color: Colors.palette.m3outline
            }
        }
    }
}
