pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import qs.common.functions
import qs

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

        const fuzzyResults = Fuzzy.go(term, otherData, {
            key: "prepared",
            limit: 30,
            threshold: -500
        });

        const fuzzyMatches = fuzzyResults.map(r => r.obj);

        return exactMatches.concat(fuzzyMatches).slice(0, 100);
    }

    function copyAndType(emoji) {
        Quickshell.execDetached(["bash", "-c", `echo -n '${emoji}' | wl-copy; ${pasteCommand}`]);
        GlobalStates.launcherOpened = false;
    }
}
