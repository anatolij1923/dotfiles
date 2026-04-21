pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

import qs.common

Singleton {
    id: root

    readonly property string niriSocket: Quickshell.env("NIRI_SOCKET")
    readonly property bool isNiri: niriSocket !== ""

    readonly property string compositor: isNiri ? "niri" : "unknown"

    Component.onCompleted: {
        if (isNiri) {
            Logger.i("WM SERVICE", "Niri detected");
        }
    }
}
