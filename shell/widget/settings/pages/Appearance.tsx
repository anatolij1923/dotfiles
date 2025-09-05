import { Gtk } from "ags/gtk4";
import { Header } from "./Header";

export default function Appearance() {
  return (
    <box class="page" hexpand orientation={Gtk.Orientation.VERTICAL}>
      <Header title="Appearance" />
    </box>
  );
}
