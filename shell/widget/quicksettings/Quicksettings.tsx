import { Astal, Gdk, Gtk } from "ags/gtk4";
import Window from "../common/Window";
import Toggles from "./modules/toggles/Toggles";
import Sliders from "./modules/sliders/Sliders";
import NotificationWindow from "./modules/notificationwindow/NotificationWindow";
import StackWidget from "./modules/stackwidget/StackWidget";
import { createState } from "ags";

export const [qsPage, setQsPage] = createState("notifications");

export default function Quicksettings(gdkmonitor: Gdk.Monitor) {
  const maxWidth = gdkmonitor.geometry.width * 0.25;
  const { TOP, BOTTOM, RIGHT } = Astal.WindowAnchor;
  return (
    <Window
      name="quicksettings"
      namespace="quicksettings"
      class="quicksettings"
      visible
      anchor={TOP | BOTTOM | RIGHT}
      keymode={Astal.Keymode.EXCLUSIVE}
      gdkmonitor={gdkmonitor}
      widthRequest={maxWidth}
      contentValign={Gtk.Align.FILL}
      contentHalign={Gtk.Align.FILL}
      contentVexpand={true}
      contentHexpand={true}
    >
      <box
        class={"quicksettings-content"}
        orientation={Gtk.Orientation.VERTICAL}
        spacing={16}
      >
        <Sliders />
        <box halign={Gtk.Align.CENTER}>
          <Toggles />
        </box>
        <StackWidget />
      </box>
    </Window>
  );
}
