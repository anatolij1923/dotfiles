import { Gtk } from "ags/gtk4";
import { Header } from "./Header";
import { SwitchRow } from "../controls/SwitchRow";
import { options } from "../../../lib/settings";
import { createState, onCleanup } from "ags";
import SpinRow from "../controls/SpinRow";
import SettingsPage from "./SettingsPage";

export default function Appearance() {
  return (
    <SettingsPage headerTitle="Appearance" className="appearance-page">
      <SwitchRow label="Dark Mode" setting={options.theme.darkMode} />
      <SwitchRow label="Bar Top" setting={options.bar.top} />
      <SwitchRow label="Corners Enabled" setting={options.corners.enabled} />
      <SwitchRow label="OSD Top" setting={options.osd.top} />
      <SpinRow
        label="OSD Margin"
        min={0}
        max={100}
        setting={options.osd.margin}
      />
    </SettingsPage>
  );
}
