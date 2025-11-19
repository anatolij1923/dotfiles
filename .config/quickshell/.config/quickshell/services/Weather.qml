pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import qs.utils

Singleton {
    id: root
    property int updateInterval: Config.weather.updateInterval || 30
    property string city: Config.weather.city

    property var data: ({
            temp: "-",
            tempFeelsLike: "-",
            city: 0,
            icon: "clear_day"
        })

    function getData() {
        let formattedCity = root.city.trim().split(/\s+/).join('+');

        let cmd = `curl -s "wttr.in/${formattedCity}?format=j1" | jq -c '{temp: .current_condition[0].temp_C, feelsLike: .current_condition[0].FeelsLikeC, city: .nearest_area[0].areaName[0].value, code: .current_condition[0].weatherCode}'`;

        fetcher.command = ["bash", "-c", cmd];
        fetcher.running = true;
    }

    Process {
        id: fetcher
        stdout: StdioCollector {
            onStreamFinished: {
                if (text.length == 0)
                    return;
                try {
                    let parsed = JSON.parse(text);

                    if (parsed.temp == "-0")
                        parsed.temp = "0";

                    parsed.icon = Icons.getWeatherIcon(parsed.code);

                    root.data = parsed;
                    console.info(`[WEATHER] Updated: ${parsed.temp}°C, Icon: ${parsed.icon}`);
                } catch (e) {
                    console.error("[WEATHER] Parse error: " + e.message);
                }
            }
        }
    }

    Timer {
        interval: root.updateInterval * 60 * 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.getData()
    }

    onCityChanged: root.getData()
}
