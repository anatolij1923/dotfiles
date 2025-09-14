import { Gtk } from "ags/gtk4";
import { Header } from "./Header";
import GLib from "gi://GLib?version=2.0";

const userName = GLib.get_user_name();

export default function About() {
  return (
    <box class="page" hexpand orientation={Gtk.Orientation.VERTICAL}>
      <Header title="About" />
      <box hexpand>
        <image
          file={`${SRC}/assets/distro_logos/cachyos.svg`}
          pixelSize={128}
        />
        <label label={userName} />
      </box>
    </box>
  );
}
