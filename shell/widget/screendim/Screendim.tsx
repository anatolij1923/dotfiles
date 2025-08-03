import { Astal, Gdk } from "ags/gtk4";

export default function Screendim(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM, RIGHT, LEFT } = Astal.WindowAnchor;
  return (
    <window gdkmonitor={gdkmonitor} visible anchor={TOP}>
      <box class="screendim">
        <label label="........." />
      </box>
    </window>
  );
}
