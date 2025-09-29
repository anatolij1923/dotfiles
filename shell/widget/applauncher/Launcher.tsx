import { Astal, Gdk, Gtk } from "ags/gtk4";
import Window from "../common/Window";
import { apps, Apps, searchApps } from "./Apps";
import Commands, { searchCommands, setCommands } from "./Commands";
import { hide, launchApplication } from "../../utils/util";
import { appsList, setAppsList } from "./states";

export default function Launcher(gdkmonitor: Gdk.Monitor) {
  const { TOP } = Astal.WindowAnchor;
  let entry: Gtk.Entry;

  function onTextChange(text: string) {
    if (text.startsWith(":")) {
      searchCommands(text);
      setAppsList([]); 
    } else {
      searchApps(text);
      setCommands([]); 
    }
  }

  function onKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number,
  ) {
    if (mod === Gdk.ModifierType.ALT_MASK) {
      for (const i of [1, 2, 3, 4, 5, 6, 7, 8, 9] as const) {
        if (keyval === Gdk[`KEY_${i}`]) {
          return (launchApplication(appsList.get()[i - 1]), hide("launcher"));
        }
      }
    }
  }

  return (
    <Window
      name="launcher"
      gdkmonitor={gdkmonitor}
      anchor={TOP}
      margin={100}
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.EXCLUSIVE}
      valign={Gtk.Align.START}
      onKey={onKey}
      onVisibilityChange={(visible) => {
        if (visible) {
          apps.reload()
          entry.grab_focus();
        } else {
          entry.set_text("");
          setAppsList([]); 
        }
      }}
      class="launcher"
    >
      <box orientation={Gtk.Orientation.VERTICAL} class="launcher-content">
        <box class="search" spacing={8}>
          <label label="search" class="material-icon" />
          <entry
            $={(ref) => (entry = ref)}
            hexpand
            onNotifyText={({ text }) => onTextChange(text)}
            placeholderText="Type : for commands "
          />
        </box>

        <Apps />
        <Commands />
        {/* TODO: add calculator */}
      </box>
    </Window>
  );
}
