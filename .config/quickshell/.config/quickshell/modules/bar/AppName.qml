import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.common
import qs.widgets

Item {
    id: root

    property bool showMoreData: false
    readonly property Toplevel activeWindow: ToplevelManager.activeToplevel

    function getAppName(win) {
        if (!win || !win.activated)
            return "Desktop";

        let initial = win.HyprlandToplevel?.lastIpcObject?.initialTitle;
        if (initial && initial !== "")
            return initial;

        let id = win.appId || win.HyprlandToplevel?.class || "";
        if (!id)
            return "Desktop";

        let parts = id.split('.');
        let junk = ["org", "com", "io", "net", "desktop", "bin", "generic"];
        let filtered = parts.filter(p => !junk.includes(p.toLowerCase()));

        let name = filtered.length > 0 ? filtered[filtered.length - 1] : parts[parts.length - 1];

        return name.charAt(0).toUpperCase() + name.slice(1);
    }

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 8

        StyledText {
            id: appLabel
            text: root.getAppName(root.activeWindow)
            weight: 400
            size: Appearance.fontSize.md
            opacity: text === "Desktop" ? 0.7 : 1
            Behavior on opacity {
                Anim {}
            }
        }

        Rectangle {
            implicitWidth: 1
            implicitHeight: 12
            color: Colors.palette.m3outline
            opacity: 0.3
            visible: root.showMoreData && root.activeWindow?.activated && titleLabel.text !== ""
        }

        StyledText {
            id: titleLabel
            visible: root.showMoreData
            property string fullTitle: root.activeWindow?.title || ""

            text: (root.activeWindow?.activated) ? (fullTitle.startsWith(appLabel.text) ? fullTitle.replace(appLabel.text, "").replace(/^[:\-\s]+/, "") : fullTitle) : ""

            opacity: 0.6
            Layout.maximumWidth: 300
            elide: Text.ElideRight
        }
    }
}
