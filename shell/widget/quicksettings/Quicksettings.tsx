import { Astal, Gdk, Gtk } from "ags/gtk4";
import Window from "../common/Window";
import Toggles from "./modules/toggles/Toggles";

export default function Quicksettings(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM, RIGHT } = Astal.WindowAnchor;
  return (
    <Window
      name="Quicksettings"
      class="quicksettings"
      visible
      anchor={TOP | RIGHT}
      keymode={Astal.Keymode.EXCLUSIVE}
      gdkmonitor={gdkmonitor}
    >
      <box
        class={"quicksettings-content"}
        orientation={Gtk.Orientation.VERTICAL}
        vexpand
        hexpand
      >
        <Toggles />
      </box>
    </Window>
  );
}
