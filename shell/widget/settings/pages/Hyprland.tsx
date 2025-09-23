import { Gtk } from "ags/gtk4";
import { Header } from "./Header";
import { SwitchRow } from "../controls/SwitchRow";
import { options } from "../../../lib/settings";
import SpinRow from "../controls/SpinRow";
import SettingsPage from "./SettingsPage";

export default function Hyprland() {
  return (
    <SettingsPage headerTitle="Hyprland" className="hyprland-page">
      <SwitchRow
        label="Enable Animations"
        setting={options.hyprland.animations.enabled}
      />
      <SpinRow
        label="Rounding"
        max={100}
        min={0}
        step={1}
        setting={options.hyprland.decoration.rounding}
      />
    </SettingsPage>
  );
}
