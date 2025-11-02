import { createState, onCleanup } from "ags";
import { exec } from "ags/process";
import Hyprland from "gi://AstalHyprland";

export default function KbLayout() {
  const hypr = Hyprland.get_default();
  const [layout, setLayout] = createState("");

  const parseLayout = (raw: string): string => {
    const low = raw.toLowerCase();
    if (low.includes("rus")) return "ru";
    if (low.includes("eng")) return "en";
    return raw.slice(0, 2).toLowerCase();
  };

  const update = () => {
    try {
      const json = JSON.parse(hypr.message("j/devices") || "{}");
      const kb = json.keyboards.find((k: any) => k.main) || json.keyboards[0];
      setLayout(kb ? parseLayout(kb.active_keymap || "") : "");
    } catch (e) {
      setLayout("");
    }
  };

  const id = hypr.connect("keyboard-layout", update);
  onCleanup(() => hypr.disconnect(id));

  update();

  return (
    <box spacing={8} class="kb-layout">
      <button
        onClicked={() =>
          exec("hyprctl switchxkblayout at-translated-set-2-keyboard next")
        }
      >
        <box spacing={8}>
          <label label={"language"} class="material-icon" />
          <label label={layout} />
        </box>
      </button>
    </box>
  );
}
