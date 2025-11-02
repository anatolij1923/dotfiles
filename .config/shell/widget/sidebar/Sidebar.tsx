import { Astal, Gdk, Gtk } from "ags/gtk4";
import Window from "../common/Window";
import WeatherBox from "./modules/weatherbox/WeatherBox";
import GLib from "gi://GLib?version=2.0";

export default function Sidebar(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM, LEFT } = Astal.WindowAnchor;

  return (
    <Window
      name="sidebar"
      namespace="sidebar"
      gdkmonitor={gdkmonitor}
      class="sidebar"
      anchor={TOP | BOTTOM | LEFT}
    >
      <box class="sidebar-content" orientation={Gtk.Orientation.VERTICAL}>
        <WeatherBox />
      </box>
    </Window>
  );
}
