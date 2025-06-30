import { createState } from "ags";
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

  hypr.connect("keyboard-layout", update);
  update();

  return (
    <box spacing={8} class="kb-layout">
      <label label={"keyboard"} class="material-icon" />
      <label label={layout} />
    </box>
  );
}
