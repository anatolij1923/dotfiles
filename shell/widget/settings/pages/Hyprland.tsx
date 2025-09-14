
import { Gtk } from "ags/gtk4";
import { Header } from "./Header";
import { SwitchRow } from "../controls/SwitchRow";
import { options } from "../../../lib/settings";

export default function Hyprland() {
  return (
    <box class="page" hexpand orientation={Gtk.Orientation.VERTICAL}>
      <Header title="Hyprland" />
      <box orientation={Gtk.Orientation.VERTICAL} spacing={16} class="page-content">
        <SwitchRow
          label="Enable Animations"
          setting={options.hyprland.animations.enabled}
        />
        {/* You can add more Hyprland settings here in the future */}
      </box>
    </box>
  );
}
