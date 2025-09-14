import { Gtk } from "ags/gtk4";
import { Header } from "./Header";
import { SwitchRow } from "../controls/SwitchRow";
import { options } from "../../../lib/settings";
import { createState, onCleanup } from "ags";

export default function Appearance() {
  return (
    <box class="page" hexpand orientation={Gtk.Orientation.VERTICAL}>
      <Header title="Appearance" />
      <box
        orientation={Gtk.Orientation.VERTICAL}
        spacing={16}
        class="page-content"
      >
        <SwitchRow label="Dark Mode" setting={options.theme.darkMode}/>
        <SwitchRow label="Bar Top" setting={options.bar.top}/>
        <SwitchRow label="Corners Enabled" setting={options.corners.enabled}/>
      </box>
    </box>
  );
}
