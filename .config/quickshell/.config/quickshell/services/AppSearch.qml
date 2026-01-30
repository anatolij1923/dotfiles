pragma Singleton

import qs.common.functions
import Quickshell
import QtQuick

/**
 * Service for application searching and icon resolution with caching.
 */
Singleton {
    id: root

    property bool sloppySearch: false
    property real scoreThreshold: 0.2

    property var iconCache: ({})

    readonly property var substitutions: ({
            "code-url-handler": "visual-studio-code",
            "Code": "visual-studio-code",
            "gnome-tweaks": "org.gnome.tweaks",
            "pavucontrol-qt": "pavucontrol",
            "wps": "wps-office2019-kprometheus",
            "wpsoffice": "wps-office2019-kprometheus",
            "footclient": "foot"
        })

    readonly property var regexSubstitutions: [
        {
            "regex": /^steam_app_(\d+)$/,
            "replace": "steam_icon_$1"
        },
        {
            "regex": /Minecraft.*/,
            "replace": "minecraft"
        },
        {
            "regex": /.*polkit.*/,
            "replace": "system-lock-screen"
        },
        {
            "regex": /gcr.prompter/,
            "replace": "system-lock-screen"
        }
    ]

    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values).sort((a, b) => a.name.localeCompare(b.name))

    readonly property var preppedNames: list.map(a => ({
                name: Fuzzy.prepare(`${a.name} ${a.genericName} ${a.comment} ${a.id} ${a.keywords.join(' ')}`),
                entry: a
            }))

    readonly property var preppedIcons: list.map(a => ({
                name: Fuzzy.prepare(`${a.icon} `),
                entry: a
            }))

    /**
     * Fuzzy search for applications.
     */
    function fuzzyQuery(search: string): var {
        if (!search || search.trim() === "")
            return list;

        return Fuzzy.go(search, preppedNames, {
            all: true,
            key: "name"
        }).map(r => r.obj.entry);
    }

    /**
     * Main entry point for icon guessing with caching.
     */
    function guessIcon(str: string): string {
        if (!str || str.length === 0)
            return "image-missing";

        if (iconCache[str])
            return iconCache[str];

        const result = _performGuess(str);

        iconCache[str] = result;
        return result;
    }

    /**
     * Internal heavy logic for icon detection.
     * Separated to keep guessIcon() clean and cache-focused.
     */
    function _performGuess(str: string): string {
        const entry = DesktopEntries.heuristicLookup(str);
        if (entry && entry.icon)
            return entry.icon;

        // Static substitutions
        const lowerStr = str.toLowerCase();
        if (substitutions[str])
            return substitutions[str];
        if (substitutions[lowerStr])
            return substitutions[lowerStr];

        // Regex substitutions
        for (let i = 0; i < regexSubstitutions.length; i++) {
            const sub = regexSubstitutions[i];
            const replaced = str.replace(sub.regex, sub.replace);
            if (replaced !== str)
                return replaced;
        }

        if (iconExists(str))
            return str;
        if (iconExists(lowerStr))
            return lowerStr;

        // Domain name (com.discordapp.Discord -> Discord)
        const reverseName = str.split('.').slice(-1)[0];
        if (iconExists(reverseName))
            return reverseName;
        if (iconExists(reverseName.toLowerCase()))
            return reverseName.toLowerCase();

        // Kebab-case (Visual Studio Code -> visual-studio-code)
        const kebab = str.toLowerCase().replace(/\s+/g, "-");
        if (iconExists(kebab))
            return kebab;

        const iconResults = Fuzzy.go(str, preppedIcons, {
            all: true,
            key: "name"
        });
        if (iconResults.length > 0) {
            const guess = iconResults[0].obj.entry.icon;
            if (iconExists(guess))
                return guess;
        }

        const nameResults = fuzzyQuery(str);
        if (nameResults.length > 0) {
            const guess = nameResults[0].icon;
            if (iconExists(guess))
                return guess;
        }

        return str;
    }

    function iconExists(iconName: string): bool {
        if (!iconName || iconName.length === 0)
            return false;
        const path = Quickshell.iconPath(iconName, true);
        return path.length > 0 && !path.includes("image-missing");
    }

    Component.onCompleted: {
        fuzzyQuery("");
    }
}
