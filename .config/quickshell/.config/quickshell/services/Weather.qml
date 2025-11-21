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
            icon: "clear_day",
            desc: "",
            wind: "0",
            humidity: "0",
            minTemp: "-",
            maxTemp: "-"
        })

    function getData() {
        let formattedCity = root.city.trim().split(/\s+/).join('+');

        let filter = "{ \
            temp: .current_condition[0].temp_C, \
            tempFeelsLike: .current_condition[0].FeelsLikeC, \
            city: .nearest_area[0].areaName[0].value, \
            code: .current_condition[0].weatherCode, \
            desc: .current_condition[0].weatherDesc[0].value, \
            wind: .current_condition[0].windspeedKmph, \
            humidity: .current_condition[0].humidity, \
            minTemp: .weather[0].mintempC, \
            maxTemp: .weather[0].maxtempC \
        }";

        let flatFilter = filter.replace(/\s+/g, ' ');

        let cmd = `curl -s "wttr.in/${formattedCity}?format=j1" | jq -c '${flatFilter}'`;

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
