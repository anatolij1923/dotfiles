pragma Singleton
import QtQuick

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    function getTrayIcon(id: string, icon: string): string {
        if (icon.includes("?path=")) {
            const [name, path] = icon.split("?path=");
            icon = Qt.resolvedUrl(`${path}/${name.slice(name.lastIndexOf("/") + 1)}`);
        }
        return icon;
    }

    function getAppIcon(name: string, fallback: string): string {
        const icon = DesktopEntries.heuristicLookup(name)?.icon;
        if (fallback !== "undefined")
            return Quickshell.iconPath(icon, fallback);
        return Quickshell.iconPath(icon);
    }

    function getNotifIcon(summary: string, urgency: int): string {
        summary = summary.toLowerCase();
        if (summary.includes("reboot"))
            return "restart_alt";
        if (summary.includes("recording"))
            return "screen_record";
        if (summary.includes("battery"))
            return "power";
        if (summary.includes("screenshot"))
            return "screenshot_monitor";
        if (summary.includes("welcome"))
            return "waving_hand";
        if (summary.includes("time") || summary.includes("a break"))
            return "schedule";
        if (summary.includes("installed"))
            return "download";
        if (summary.includes("update"))
            return "update";
        if (summary.includes("unable to"))
            return "deployed_code_alert";
        if (summary.includes("profile"))
            return "person";
        if (summary.includes("file"))
            return "folder_copy";
        if (urgency === NotificationUrgency.Critical)
            return "release_alert";
        return "chat";
    }
}
