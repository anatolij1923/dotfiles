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

    function getWeatherIcon(code) {
        // Код приходит строкой из JSON, преобразуем в число
        var c = parseInt(code);

        // Коды WWO: https://worldweatheronline.com/weather-api/api/docs/weather-icons.aspx

        // Ясно / Солнечно
        if (c === 113)
            return "sunny";

        // Переменная облачность
        if (c === 116)
            return "partly_cloudy_day";

        // Пасмурно / Облачно
        if (c === 119 || c === 122)
            return "cloud";

        // Туман / Дымка
        if (c === 143 || c === 248 || c === 260)
            return "foggy";

        // Дождь (легкий, средний, ливень)
        if ([176, 263, 266, 293, 296, 299, 302, 305, 308, 311, 314, 353, 356, 359].includes(c))
            return "rainy";

        // Снег / Метель
        if ([227, 230, 323, 326, 329, 332, 335, 338, 368, 371, 392, 395].includes(c))
            return "weather_snowy";

        // Снег с дождем / Град
        if ([281, 284, 317, 320, 350, 362, 365, 374, 377].includes(c))
            return "weather_mix";

        // Гроза
        if ([386, 389].includes(c))
            return "thunderstorm";

        // Если код неизвестен
        return "question_mark";
    }
}
