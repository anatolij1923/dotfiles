import { createState, For } from "ags";
import { Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { execAsync } from "ags/process";
import { hide, HOME } from "../../utils/util";
import GLib from "gi://GLib?version=2.0";
import { switchTheme } from "../../utils/switchTheme";
import { timeout } from "ags/time";

// TODO: add more commands

export const [commands, setCommands] = createState<Command[]>([]);

export interface Command {
  name: string;
  description: string;
  action: () => void;
}

const commandList: Command[] = [
  {
    name: "up",
    description: "Update system",
    action: () => {
      const term = GLib.getenv("TERM");
      execAsync(["ghostty", "-e", "yay"]);
    },
  },
  {
    name: "th",
    description: "Switch dark/light theme",
    action: () => {
      switchTheme();
      timeout(50, execAsync([`${HOME}/.config/hypr/scripts/wallpaper.sh`]));
    },
  },
  {
    name: "hc",
    description: "Show Hypr clients",
    action: () => {
      execAsync(["ghostty", "-e", "sh", "-c", "hyprctl clients; exec $SHELL"]);
    },
  },
  {
    name: "notify",
    description: "Send notification",
    action: () => {
      execAsync(["notify-send", "test", "text"]);
    },
  },
  {
    name: "notify2",
    description: "send two notifications",
    action: () => {
      execAsync(["notify-send", "test", "text"]);
      execAsync(["notify-send", "test", "text"]);
    },
  },
];

function fuzzyMatch(str: string, pattern: string) {
  str = str.toLowerCase();
  pattern = pattern.toLowerCase();

  let i = 0,
    j = 0;
  while (i < str.length && j < pattern.length) {
    if (str[i] === pattern[j]) j++;
    i++;
  }
  return j === pattern.length;
}

export function searchCommands(text: string) {
  if (!text || !text.startsWith(":")) {
    setCommands([]);
    return;
  }

  const query = text.slice(1).toLowerCase();

  const filtered = commandList.filter(
    (c) => fuzzyMatch(c.name, query)
    || fuzzyMatch(c.description, query),
  );

  filtered.sort((a, b) => {
    if (a.name === query) return -1;
    if (b.name === query) return 1;
    return 0;
  });

  setCommands(filtered.slice(0, 8));
}

export default function Commands() {
  function launchCommand(cmd: Command) {
    cmd.action();
    hide("launcher");
  }

  return (
    <revealer
      revealChild={commands((l) => l.length > 0)}
      transitionDuration={170}
    >
      <box orientation={Gtk.Orientation.VERTICAL} class="command-list">
        <For each={commands}>
          {(cmd) => (
            <button onClicked={() => launchCommand(cmd)}>
              <box>
                <label label={cmd.name} class="command-name" />
                <label
                  label={cmd.description}
                  halign={Gtk.Align.END}
                  hexpand
                  class="command-desc"
                />
              </box>
            </button>
          )}
        </For>
      </box>
    </revealer>
  );
}
