import { Astal, Gdk, Gtk } from "ags/gtk4";
import Window from "../common/Window";
import Toggles from "./modules/toggles/Toggles";
import Sliders from "./modules/sliders/Sliders";
import Header from "./modules/header/Header";
import NotificationWindow from "./modules/notificationwindow/NotificationWindow";
import Mediaplayer from "./modules/mediaplayer/Mediaplayer";
import app from "ags/gtk4/app";
import { createState } from "ags";

export default function Quicksettings(gdkmonitor: Gdk.Monitor) {
  const maxWidth = gdkmonitor.geometry.width * 0.25;
  const { TOP, BOTTOM, RIGHT } = Astal.WindowAnchor;

  const [reveal, setReveal] = createState(false);

  return (
    <Window
      name="quicksettings"
      namespace="quicksettings"
      class="quicksettings"
      anchor={TOP | BOTTOM | RIGHT}
      keymode={Astal.Keymode.EXCLUSIVE}
      gdkmonitor={gdkmonitor}
      contentValign={Gtk.Align.FILL}
      contentHalign={Gtk.Align.FILL}
      contentHexpand={true}
      contentVexpand={true}
      onVisibilityChange={(visible) => {
        setReveal(visible);
      }}
    >
      <revealer
        transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
        revealChild={reveal}
        transition_duration={250}
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
          <NotificationWindow />
        </box>
      </revealer>
    </Window>
  );
}
