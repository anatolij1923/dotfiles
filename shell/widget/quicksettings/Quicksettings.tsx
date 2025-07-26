import { Astal, Gdk, Gtk } from "ags/gtk4";
import Window from "../common/Window";
import Toggles from "./modules/toggles/Toggles";
import Sliders from "./modules/sliders/Sliders";
import StackWidget from "./modules/stackwidget/StackWidget";
import { createState } from "ags";
import Adw from "gi://Adw?version=1";
import Mediaplayer from "./modules/mediaplayer/Mediaplayer";
import Header from "./modules/header/Header";

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
      contentValign={Gtk.Align.FILL}
      contentHalign={Gtk.Align.FILL}
      contentHexpand={true}
      contentVexpand={true}
    >
      <box
        widthRequest={maxWidth}
        class={"quicksettings-content"}
        orientation={Gtk.Orientation.VERTICAL}
        spacing={16}
      >
        <Header />
        <Sliders />
        <Toggles />
        {/* <Mediaplayer /> */}
        {/* <StackWidget /> */}
      </box>
    </Window>
  );
}
