pragma Singleton

import qs.common.functions
import Quickshell
import QtQuick
import qs.common

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

    readonly property var preppedNamesOnly: list.map(a => ({
                name: Fuzzy.prepare(a.name),
                entry: a
            }))

    readonly property var preppedIcons: list.map(a => ({
                name: Fuzzy.prepare(`${a.icon} `),
                entry: a
            }))

    /**
     * Fuzzy search for applications with Frecency integration.
     */
    function fuzzyQuery(search: string): var {
        // 1. Empty Search: Return Top-8 most used apps
        if (!search || search.trim() === "") {
            // Reset highlights
            list.forEach(entry => {
                entry.highlightedName = undefined;
            });

            // Create a copy to sort by frecency score
            let topApps = [...list];
            topApps.sort((a, b) => {
                let scoreA = LauncherStats.getScore(a.id);
                let scoreB = LauncherStats.getScore(b.id);
                
                // Sort by score DESC
                if (scoreA !== scoreB) return scoreB - scoreA;
                
                // Fallback: Sort by name ASC
                return a.name.localeCompare(b.name);
            });

            // Return only the top 8 (simulate "Recents" view)
            // You can remove .slice(0, 8) if you want to show ALL apps sorted by frequency
            // return topApps.slice(0, 8);
            return topApps
        }

        // 2. Active Search: Fuzzy + Frecency
        const searchResults = Fuzzy.go(search, preppedNames, {
            all: true,
            key: "name"
        });
        
        // Get name-only results for highlighting purposes
        const nameOnlyResults = Fuzzy.go(search, preppedNamesOnly, {
            all: true,
            key: "name"
        });
        
        // Map for highlighting lookup
        const nameHighlightMap = {};
        nameOnlyResults.forEach(nameResult => {
            const entryId = nameResult.obj.entry.id;
            nameHighlightMap[entryId] = nameResult;
        });
        
        return searchResults.map(r => {
            const entry = r.obj.entry;
            const nameResult = nameHighlightMap[entry.id];
            
            // Highlight logic
            let highlighted = entry.name; 
            if (nameResult) {
                highlighted = nameResult.highlight(`<u><font color="${Colors.palette.m3primary}">`, "</font></u>");
            }
            entry.highlightedName = highlighted;

            // --- Frecency Logic ---
            const fScore = LauncherStats.getScore(entry.id);
            
            // Combine Fuzzy Score (usually negative) with Frecency Bonus.
            // Multiplier 10 makes usage history significant but preserves fuzzy accuracy.
            entry.combinedScore = r.score + (fScore * 10);

            return entry;
        }).sort((a, b) => b.combinedScore - a.combinedScore); // Sort by combined score
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

        // Domain name
        const reverseName = str.split('.').slice(-1)[0];
        if (iconExists(reverseName))
            return reverseName;
        if (iconExists(reverseName.toLowerCase()))
            return reverseName.toLowerCase();

        // Kebab-case
        const kebab = str.toLowerCase().replace(/\s+/g, "-");
        if (iconExists(kebab))
            return kebab;

        // Fuzzy icons
        const iconResults = Fuzzy.go(str, preppedIcons, {
            all: true,
            key: "name"
        });
        if (iconResults.length > 0) {
            const guess = iconResults[0].obj.entry.icon;
            if (iconExists(guess))
                return guess;
        }

        // Fuzzy names fallback
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
        Logger.i("AppSearch", "Initialized. Stats Ready: " + LauncherStats.ready);
    }
}
