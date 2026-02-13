pragma Singleton

import qs.common.functions
import Quickshell
import QtQuick
import qs.common
import qs.config // Import Config to access useStatsForApps

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
     * Fuzzy search for applications with optional Frecency integration.
     */
    function fuzzyQuery(search: string): var {
        // ---------------------------------------------------------
        // 1. EMPTY SEARCH STRATEGY
        // ---------------------------------------------------------
        if (!search || search.trim() === "") {
            // Reset highlights
            list.forEach(entry => {
                entry.highlightedName = undefined;
            });

            // Check if stats are enabled in config
            if (Config.launcher.useStatsForApps) {
                // Copy and sort by usage score
                let topApps = [...list];
                topApps.sort((a, b) => {
                    let scoreA = LauncherStats.getScore(a.id);
                    let scoreB = LauncherStats.getScore(b.id);
                    if (scoreA !== scoreB)
                        return scoreB - scoreA;
                    return a.name.localeCompare(b.name);
                });
                // Return top 8 most used apps
                return topApps.slice(0, 8);
            } else {
                // Return standard alphabetical list
                return list;
            }
        }

        const lowerSearch = search.toLowerCase();

        // ---------------------------------------------------------
        // 2. ACTIVE SEARCH STRATEGY
        // ---------------------------------------------------------

        // Get raw fuzzy results
        // threshold: -5000 filters out irrelevant noise
        const searchResults = Fuzzy.go(search, preppedNames, {
            all: true,
            key: "name",
            threshold: -5000
        });

        // Prepare highlighting map
        const nameOnlyResults = Fuzzy.go(search, preppedNamesOnly, {
            all: true,
            key: "name"
        });
        const nameHighlightMap = {};
        nameOnlyResults.forEach(nr => {
            nameHighlightMap[nr.obj.entry.id] = nr;
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

            // --- SCORE CALCULATION ---

            let baseScore = 0;
            const lowerName = entry.name.toLowerCase();
            const lowerId = entry.id.toLowerCase();
            const lowerExec = (entry.exec || "").toLowerCase();

            // TIER 1: Exact start of name (Highest Priority)
            // Ex: "fire" -> "Firefox"
            if (lowerName.startsWith(lowerSearch)) {
                baseScore = 100000;
            } else
            // TIER 2: Contains the full word
            // Ex: "code" -> "Visual Studio Code"
            if (lowerName.includes(lowerSearch)) {
                baseScore = 50000;
            } else
            // TIER 3: Match in ID or Exec command
            // Ex: "code" -> "cursor" (if id=cursor.desktop)
            if (lowerId.includes(lowerSearch) || lowerExec.includes(lowerSearch)) {
                baseScore = 10000;
            } else
            // TIER 4: Pure Fuzzy (characters exist but scattered)
            // Keeps original library score (negative value)
            {
                baseScore = r.score;
            }

            // BONUS: Frecency Stats
            // Only apply if enabled in config
            let statsBonus = 0;
            if (Config.launcher.useStatsForApps) {
                statsBonus = LauncherStats.getScore(entry.id);
                // Cap the bonus to 500 so stats never override Tiers
                // (e.g. Tier 4 with high stats should not beat Tier 2)
                if (statsBonus > 500)
                    statsBonus = 500; 
            }

            // Final combined score
            entry._finalScore = baseScore + statsBonus;

            return entry;
        })
        // Filter out very poor matches
        .filter(entry => entry._finalScore > -2000).sort((a, b) => b._finalScore - a._finalScore);
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
    }
}
