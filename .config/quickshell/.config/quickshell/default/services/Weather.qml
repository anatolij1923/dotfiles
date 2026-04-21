pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.config
import qs.common

Singleton {
    id: root
    property int updateInterval: Config.weather.updateInterval || 30
    property string city: Config.weather.city

    property var data: ({
            temp: "-",
            tempFeelsLike: "-",
            city: "Loading...",
            icon: "clear_day",
            desc: "",
            wind: "0",
            humidity: "0",
            minTemp: "-",
            maxTemp: "-",
            forecast: []
        })

    function getData() {
        if (!root.city)
            return;
        let formattedCity = root.city.trim().split(/\s+/).join('+');

        let filter = "{ \
            current: { \
                temp: .current_condition[0].temp_C, \
                tempFeelsLike: .current_condition[0].FeelsLikeC, \
                city: .nearest_area[0].areaName[0].value, \
                code: .current_condition[0].weatherCode, \
                desc: .current_condition[0].weatherDesc[0].value, \
                wind: .current_condition[0].windspeedKmph, \
                humidity: .current_condition[0].humidity, \
                minTemp: .weather[0].mintempC, \
                maxTemp: .weather[0].maxtempC \
            }, \
            forecast: [.weather[] | { \
                date: .date, \
                avg: .avgtempC, \
                max: .maxtempC, \
                min: .mintempC, \
                code: .hourly[4].weatherCode \
            }] \
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
                    let result = parsed.current;

                    if (result.temp === "-0")
                        result.temp = "0";
                    result.icon = Icons.getWeatherIcon(result.code);

                    const daysShort = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

                    result.forecast = parsed.forecast.map((item, index) => {
                        let dayName = "";
                        if (index === 0) {
                            dayName = "Today";
                        } else {
                            let dateParts = item.date.split('-');
                            let d = new Date(dateParts[0], dateParts[1] - 1, dateParts[2]);
                            dayName = daysShort[d.getDay()];
                        }

                        return {
                            day: dayName,
                            icon: Icons.getWeatherIcon(item.code),
                            avg: item.avg,
                            max: item.max,
                            min: item.min
                        };
                    });

                    root.data = result;
                    Logger.i("WEATHER", `Updated for ${result.city}`);
                } catch (e) {
                    Logger.e("WEATHER", "Parse error: " + e.message);
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
