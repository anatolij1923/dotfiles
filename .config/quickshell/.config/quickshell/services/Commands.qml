pragma Singleton

import qs.modules.common
import qs.modules.common.functions
import qs.config
import Quickshell
import QtQuick

/**
 * Service for fuzzy searching commands
 */
Singleton {
    id: root

    function getCommandsList() {
        try {
            const cmd = Config.launcher.commands;
            // console.log("Commands.qml: Config.launcher.command =", JSON.stringify(cmd));

            let commands = [];

            // Handle both array and single object
            if (Array.isArray(cmd)) {
                commands = cmd;
            } else if (cmd && typeof cmd === "object") {
                commands = [cmd];
            }

            // console.log("Commands.qml: commands array length =", commands.length);

            if (!commands || commands.length === 0) {
                // console.log("Commands.qml: No commands found");
                return [];
            }

            // Convert QML objects to plain JS objects via JSON
            // Handle case where commands might be a QML list that stringifies differently
            let plainCommands;
            try {
                const jsonStr = JSON.stringify(commands);
                // console.log("Commands.qml: JSON string =", jsonStr);
                plainCommands = JSON.parse(jsonStr);
                // If it's nested array, flatten it
                if (Array.isArray(plainCommands) && plainCommands.length > 0 && Array.isArray(plainCommands[0])) {
                    // console.log("Commands.qml: Detected nested array, flattening");
                    plainCommands = plainCommands[0];
                }
            } catch (e) {
                // console.error("Commands.qml: JSON parse error:", e);
                // Fallback: try to access properties directly
                plainCommands = commands;
            }

            // console.log("Commands.qml: plainCommands =", JSON.stringify(plainCommands));
            // console.log("Commands.qml: plainCommands type =", typeof plainCommands, "isArray =", Array.isArray(plainCommands));

            if (!Array.isArray(plainCommands)) {
                // console.log("Commands.qml: plainCommands is not an array, converting");
                plainCommands = [plainCommands];
            }

            const filtered = plainCommands.filter(cmd => {
                if (!cmd || typeof cmd !== "object") {
                    // console.log("Commands.qml: skipping invalid cmd");
                    return false;
                }

                const name = (cmd.name || "").trim();
                const action = cmd.action;
                const commandField = cmd.command;
                const command = commandField || action || [];

                // console.log("Commands.qml: checking cmd:", name, "action:", JSON.stringify(action), "command:", JSON.stringify(commandField));

                // Check that name is not empty
                if (!name || name.length === 0) {
                    // console.log("Commands.qml: name is empty");
                    return false;
                }

                // Check command/action array
                let commandArray = [];
                if (Array.isArray(command)) {
                    commandArray = command;
                } else if (command) {
                    commandArray = [command];
                }

                if (commandArray.length === 0) {
                    // console.log("Commands.qml: command array is empty");
                    return false;
                }

                const hasValidCommand = commandArray.some(c => {
                    const str = String(c || "");
                    return str.trim().length > 0;
                });
                // console.log("Commands.qml: hasValidCommand =", hasValidCommand);
                return hasValidCommand;
            });

            // console.log("Commands.qml: filtered commands count =", filtered.length);

            const mappedCommands = filtered.map(cmd => ({
                        name: (cmd.name || "").trim(),
                        description: (cmd.description || "").trim(),
                        icon: (cmd.icon || "help_outline").trim() || "help_outline",
                        command: cmd.command || cmd.action || []
                    }));

            // mappedCommands.push({
            //     name: "wallpaper",
            //     description: "Open wallpaper selector",
            //     icon: "wallpaper",
            //     command: ["autocomplete", "wallpaper"]
            // });

            return mappedCommands;
        } catch (e) {
            // console.error("Commands.qml: Error in getCommandsList:", e);
            return [];
        }
    }

    function query(search: string): var {
        // console.log("Commands.qml: query called with search =", search);
        const list = getCommandsList();
        // console.log("Commands.qml: list length =", list.length);

        if (!search || search.length === 0) {
            // console.log("Commands.qml: returning full list");
            return list;
        }

        const preppedCommands = list.map(cmd => ({
                    name: Fuzzy.prepare(`${cmd.name ?? ""} ${cmd.description ?? ""}`),
                    command: cmd
                }));

        const results = Fuzzy.go(search, preppedCommands, {
            all: true,
            key: "name"
        }).map(r => {
            return r.obj.command;
        });

        // console.log("Commands.qml: search results count =", results.length);
        return results;
    }
}
