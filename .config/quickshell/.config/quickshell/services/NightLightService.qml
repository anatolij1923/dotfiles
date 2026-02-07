pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.common

/**
 * Service for managing sunsetr (blue light filter) process.
 * Start only via: sunsetr restart -b
 * Stop: sunsetr stop
 * Config: sunsetr get/set night_temp, night_gamma (and optionally day_*)
 */
Singleton {
    id: root

    property bool running: false
    property int temperature: 3300   // night_temp, 1000-20000 K
    property real gamma: 90           // night_gamma, 10-100%

    property bool _stopCooldown: false

    function start() {
        Logger.i("NightLightService", "start: sunsetr restart -b");
        root._stopCooldown = false;
        stopCooldownTimer.stop();
        Quickshell.execDetached(["sunsetr", "restart", "-b"]);
        statusCheckTimer.restart();
    }

    function stop() {
        Logger.i("NightLightService", "stop: sunsetr stop");
        Quickshell.execDetached(["sunsetr", "stop"]);
        root.running = false;
        root._stopCooldown = true;
        stopCooldownTimer.start();
    }

    function toggle() {
        if (root.running)
            stop();
        else
            start();
    }

    function refreshState() {
        statusProc.running = true;
    }

    function refreshConfig() {
        Logger.i("NightLightService", "refreshConfig");
        getProc.running = true;
    }

    readonly property int _setDebounceMs: 400

    function setTemperature(value) {
        const v = Math.round(Math.max(1000, Math.min(20000, value)));
        root.temperature = v;
        commitTempTimer.restart();
    }

    function setGamma(value) {
        const v = Math.max(10, Math.min(200, Math.round(value * 10) / 10));
        root.gamma = v;
        commitGammaTimer.restart();
    }

    Timer {
        id: commitTempTimer
        interval: root._setDebounceMs
        onTriggered: {
            const cmd = ["sunsetr", "set", "night_temp=" + root.temperature];
            Logger.i("NightLightService", "setTemperature", root.temperature, "->", cmd.join(" "));
            Quickshell.execDetached(cmd);
        }
    }

    Timer {
        id: commitGammaTimer
        interval: root._setDebounceMs
        onTriggered: {
            const cmd = ["sunsetr", "set", "night_gamma=" + root.gamma];
            Logger.i("NightLightService", "setGamma", root.gamma, "->", cmd.join(" "));
            Quickshell.execDetached(cmd);
        }
    }

    Timer {
        id: stopCooldownTimer
        interval: 5000
        onTriggered: {
            root._stopCooldown = false;
            Logger.i("NightLightService", "stop cooldown ended");
        }
    }

    Timer {
        id: statusCheckTimer
        interval: 2000
        onTriggered: {
            if (root._stopCooldown) {
                Logger.i("NightLightService", "status check skipped (stop cooldown)");
                return;
            }
            statusProc.running = true;
        }
    }

    Process {
        id: statusProc
        command: ["sunsetr", "status", "--json"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const o = JSON.parse(text);
                    if (o.current_temp !== undefined)
                        root.temperature = Math.round(o.current_temp);
                    if (o.current_gamma !== undefined)
                        root.gamma = Math.round(o.current_gamma * 10) / 10;
                } catch (_) {}
            }
        }
        onExited: exitCode => {
            if (root._stopCooldown) {
                Logger.i("NightLightService", "status exited", exitCode, "(cooldown, keeping running=false)");
                root.running = false;
                return;
            }
            root.running = (exitCode === 0);
            Logger.i("NightLightService", "status exited", exitCode, "-> running =", root.running);
        }
    }

    Process {
        id: getProc
        command: ["sunsetr", "get", "night_temp", "night_gamma", "--json"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const o = JSON.parse(text);
                    if (o.night_temp !== undefined)
                        root.temperature = o.night_temp;
                    if (o.night_gamma !== undefined)
                        root.gamma = o.night_gamma;
                    Logger.i("NightLightService", "get -> temp", root.temperature, "gamma", root.gamma);
                } catch (e) {
                    Logger.e("NightLightService", "get parse error", String(e));
                }
            }
        }
    }

    Component.onCompleted: {
        statusProc.running = true;
    }
}
