pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property bool isDebug: true

    readonly property string c_reset: "\x1b[0m"
    readonly property string c_gray: "\x1b[90m"
    readonly property string c_cyan: "\x1b[36m"

    readonly property string tag_info: "\x1b[30;44m INFO \x1b[0m"
    readonly property string tag_success: "\x1b[30;42m SUCCESS \x1b[0m"
    readonly property string tag_warn: "\x1b[30;43m WARN \x1b[0m"
    readonly property string tag_error: "\x1b[30;41m ERROR \x1b[0m"

    function _formatMessage(tag, args) {
        const time = new Date().toLocaleTimeString("en-US", {
            hour12: false
        });
        const timeStr = `${c_gray}[${time}]${c_reset}`;

        let module = "SHELL";
        let message = "";

        if (args.length > 1) {
            module = args.shift().toString().toUpperCase();
            message = args.join(" ");
        } else {
            message = args[0];
        }

        let moduleWithBrackets = `[${module}]`;

        const moduleStr = `${c_cyan}${moduleWithBrackets.padStart(14, " ")}${c_reset}`;

        return `${timeStr} ${tag} ${moduleStr} | ${message}`;
    }

    function i(...args) {
        console.info(_formatMessage(tag_info, args));
    }
    function s(...args) {
        console.info(_formatMessage(tag_success, args));
    }
    function w(...args) {
        console.warn(_formatMessage(tag_warn, args));
    }
    function e(...args) {
        console.error(_formatMessage(tag_error, args));
    }

    function trace() {
        const fullStack = new Error().stack.split('\n');
        const stack = fullStack.slice(1).join('\n');

        if (stack.trim().length > 0) {
            console.log(`${c_gray}--- CALL STACK ---\n${stack}\n------------------${c_reset}`);
        } else {
            console.log(`${c_gray}--- CALL STACK: No JS caller (top level) ---${c_reset}`);
        }
    }
}
