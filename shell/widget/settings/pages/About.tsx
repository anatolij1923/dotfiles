import { Gtk } from "ags/gtk4";
import { Header } from "./Header";
import GLib from "gi://GLib?version=2.0";
import SettingsPage from "./SettingsPage";

const userName = GLib.get_user_name();

export default function About() {
  return (
    <SettingsPage headerTitle="About" className="page">
      <image
        file={`${SRC}/assets/distro_logos/cachyos.svg`}
        pixelSize={128}
      />
      <label label={userName} />

    </SettingsPage>
  );
}
