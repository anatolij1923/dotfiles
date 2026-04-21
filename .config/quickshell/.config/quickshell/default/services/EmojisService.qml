pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.common.functions
import qs
import qs.common

Singleton {
    id: root

    property var emojiData: []
    property bool loaded: false
    property string pasteCommand: "wtype -M ctrl v"

    FileView {
        id: emojiFile
        path: Quickshell.shellDir + "/assets/emojis.txt"

        onLoaded: {
            const content = text();
            const lines = content.split("\n");
            const buffer = [];

            for (let i = 0; i < lines.length; i++) {
                const line = lines[i].trim();
                if (line === "" || line.startsWith("#"))
                    continue;

                const parts = line.split(/\s+/);
                const emoji = parts[0];
                const description = parts.slice(1).join(" ");

                buffer.push({
                    emoji: emoji,
                    description: description.toLowerCase(),
                    prepared: Fuzzy.prepare(description)
                });
            }

            root.emojiData = buffer;
            root.loaded = true;
            Logger.i("EmojiService", `Loaded ${buffer.length} emojis`);
        }
    }

    function query(search) {
        if (!root.loaded || root.emojiData.length === 0)
            return [];

        const term = search.replace(/^:emoji\s*/, "").toLowerCase().trim();

        if (term === "") {
            // Clear any highlight properties when search is empty
            root.emojiData.forEach(item => {
                item.highlightedDescription = undefined;
            });
            return root.emojiData.slice(0, 100);
        }

        const exactMatches = [];
        const otherData = [];

        for (let i = 0; i < root.emojiData.length; i++) {
            const item = root.emojiData[i];
            if (item.description.includes(term)) {
                exactMatches.push(item);
            } else {
                otherData.push(item);
            }
        }

        // Perform fuzzy search on other data
        const fuzzyResults = Fuzzy.go(term, otherData, {
            key: "prepared",
            limit: 30,
            threshold: -500
        });

        // Apply highlighting to fuzzy matches
        const fuzzyMatches = fuzzyResults.map(r => {
            const item = r.obj;
            // Highlight the description using the theme color and underlining
            item.highlightedDescription = r.highlight(`<u><font color="${Colors.palette.m3primary}">`, "</font></u>");
            return item;
        });

        // Apply highlighting to exact matches
        const exactMatchesWithHighlight = exactMatches.map(item => {
            // Manually highlight the matching part in the description
            const regex = new RegExp(`(${term})`, 'gi');
            item.highlightedDescription = item.description.replace(regex, `<u><font color="${Colors.palette.m3primary}">$1</font></u>`);
            return item;
        });

        return exactMatchesWithHighlight.concat(fuzzyMatches).slice(0, 100);
    }

    function copyAndType(emoji) {
        Quickshell.execDetached(["bash", "-c", `echo -n '${emoji}' | wl-copy; ${pasteCommand}`]);
        GlobalStates.launcherOpened = false;
    }
}
