pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.common

/**
 * Service for managing sunsetr (blue light filter) process.
 */
Singleton {
    id: root

    property bool running: false
    property int temperature
    property real gamma

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
        configFile.reload();
    }

    function _parseConfig(text) {
        const tempMatch = text.match(/night_temp\s*=\s*(\d+)/);
        const gammaMatch = text.match(/night_gamma\s*=\s*([\d.]+)/);
        if (tempMatch)
            root.temperature = parseInt(tempMatch[1], 10);
        if (gammaMatch)
            root.gamma = parseFloat(gammaMatch[1]);
    }

    FileView {
        id: configFile
        path: `${Paths.config}/sunsetr/sunsetr.toml`
        onLoaded: root._parseConfig(text())
        onLoadFailed: err => {
            if (err === FileViewError.FileNotFound) {
                Logger.w("NightLightService", "Config not found");
            } else {
                Logger.e("NightLightService", "Config load failed", String(err));
            }
        }
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
        triggeredOnStart: true
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
            onStreamFinished: { /* temp/gamma from config file only */ }
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

    Component.onCompleted: {
        statusProc.running = true;
    }
}
