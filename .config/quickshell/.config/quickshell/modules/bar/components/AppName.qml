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
            return Translation.tr("appname.desktop");

        let id = win.appId || win.HyprlandToplevel?.class || "";
        if (!id)
            return Translation.tr("appname.desktop");

        const friendlyNames = {
            "thorium-browser": "Thorium",
            "google-chrome": "Google Chrome",
            "firefox": "Firefox",
            "org.gnome.Nautilus": "Files",
            "com.mitchellh.ghostty": "Ghostty",
            "org.quickshell": "Quickshell",
            "code-oss": "VS Code",
            "visual-studio-code-bin": "VS Code",
            "discord": "Discord",
            "vesktop": "Vesktop",
            "spotify": "Spotify",
            "telegram-desktop": "Telegram",
            "org.kde.dolphin": "Dolphin"
        };

        if (friendlyNames[id])
            return friendlyNames[id];

        let name = id.replace(/\.desktop$/, "");

        let parts = name.split('.');
        let junk = ["org", "com", "io", "net", "desktop", "bin", "generic", "apps", "linux"];
        let filtered = parts.filter(p => !junk.includes(p.toLowerCase()));

        name = filtered.length > 0 ? filtered[filtered.length - 1] : parts[parts.length - 1];

        name = name.replace(/-browser$/, "").replace(/[-_]/g, " ");

        return name.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ');
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
            weight: 500
            size: Appearance.fontSize.md
            color: Colors.palette.m3onSurface
            opacity: text === Translation.tr("appname.desktop") ? 0.5 : 1
        }


        Rectangle {
            implicitWidth: 1
            implicitHeight: 14
            color: Colors.palette.m3outline
            opacity: 0.3
            visible: titleLabel.text !== "" && titleLabel.visible
        }

        StyledText {
            id: titleLabel
            visible: root.showMoreData

            property string rawTitle: root.activeWindow?.title || ""

            text: {
                if (!root.activeWindow?.activated || rawTitle === appLabel.text)
                    return "";

                let cleanTitle = rawTitle.replace(new RegExp(`[\\s\\-\\|·]*${appLabel.text}$`, "i"), "");
                return cleanTitle.trim();
            }

            opacity: 0.7
            size: Appearance.fontSize.sm
            Layout.maximumWidth: 400
            elide: Text.ElideRight
        }
    }
}
