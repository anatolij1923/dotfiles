pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.services
import qs.common
import qs.common.functions

Singleton {
    id: root

    property string cliphistBinary: "cliphist"
    property string pasteCommand: "wtype -M ctrl v"

    property list<string> entries: []
    property var preparedEntries: []
    property var searchResultsMap: ({})

    onEntriesChanged: {
        const startTime = Date.now();
        try {
            preparedEntries = entries.map(entry => {
                const cleanText = entry.replace(/^\d+\t/, "");
                return {
                    original: entry,
                    clean: cleanText,
                    prepared: Fuzzy.prepare(cleanText)
                };
            });
            const endTime = Date.now();
            Logger.i("ClipboardService", `Indexed ${entries.length} items in ${endTime - startTime}ms`);
        } catch (e) {
            Logger.e("ClipboardService", `Error: ${e.message}`);
        }
    }

    function query(search) {
        if (!search || search.trim() === "") {
            // Clear any highlight properties when search is empty
            preparedEntries.forEach(item => {
                item.highlightedClean = undefined;
            });
            return entries;
        }
        try {
            // Clear the search results map when search is empty
            if (!search || search.trim() === "") {
                root.searchResultsMap = {};
                return entries;
            }
            const results = Fuzzy.go(search, preparedEntries, {
                key: "prepared",
                limit: 100,
                threshold: -10000
            });
            // Create a new search results map for this search
            const newSearchResultsMap = {};
            // Apply highlighting to the results
            const returnResults = results.map(r => {
                const item = r.obj;
                item.highlightedClean = r.highlight(`<u><font color="${Colors.palette.m3primary}">`, "</font></u>");
                // Store the highlighted version in the map using the original entry as key
                newSearchResultsMap[item.original] = item.highlightedClean;
                return item.original;
            });
            // Update the search results map
            root.searchResultsMap = newSearchResultsMap;
            return returnResults;
        } catch (e) {
            return [];
        }
    }

    function refresh() {
        if (readProc.running)
            return;
        readProc.running = true;
    }

    function copy(entry) {
        const cmd = `printf ${shellEscape(entry)} | ${cliphistBinary} decode | wl-copy`;
        Quickshell.execDetached(["bash", "-c", cmd]);
    }

    function paste(entry) {
        const cmd = `printf ${shellEscape(entry)} | ${cliphistBinary} decode | wl-copy; ${pasteCommand}`;
        Quickshell.execDetached(["bash", "-c", cmd]);
    }

    function remove(entry) {
        removeProc.removeEntry(entry);
    }

    function wipe() {
        wipeProc.running = true;
        refresh();
    }

    function shellEscape(str) {
        if (!str)
            return "''";
        return "'" + str.replace(/'/g, "'\\''") + "'";
    }

    function isImage(entry) {
        return !!entry.match(/^\d+\t\[\[.*binary data.*\]\]/);
    }

    Process {
        id: readProc
        command: [root.cliphistBinary, "list"]
        stdout: SplitParser {
            id: stdOutParser
            property var buffer: []
            onRead: line => buffer.push(line)
        }
        onExited: exitCode => {
            if (exitCode === 0)
                root.entries = stdOutParser.buffer;
            stdOutParser.buffer = [];
        }
    }

    Process {
        id: removeProc
        property string entry: ""

        function removeEntry(e) {
            if (!e)
                return;
            removeProc.entry = e;
            removeProc.command = ["bash", "-c", `printf ${root.shellEscape(removeProc.entry)} | ${root.cliphistBinary} delete`];
            removeProc.running = true;
        }

        onExited: (exitCode, exitStatus) => {
            root.refresh();
            removeProc.entry = "";
            if (exitCode === 0)
                Logger.i("ClipboardService", "Entry removed");
            else
                Logger.e("ClipboardService", "Failed to remove entry");
        }
    }

    Process {
        id: wipeProc
        command: [root.cliphistBinary, "wipe"]
        onExited: (exitCode, exitStatus) => {
            root.refresh();
        }
    }

    Connections {
        target: Quickshell
        function onClipboardTextChanged() {
            updateTimer.restart();
        }
    }

    Timer {
        id: updateTimer
        interval: 50
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
