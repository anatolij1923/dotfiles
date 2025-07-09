import { Astal, Gdk, Gtk } from "ags/gtk4";
import Wp from "gi://AstalWp";
import Brightness from "../../lib/brightness";
import { createBinding, createState } from "ags";
import { timeout } from "ags/time";
import cairo from "gi://cairo?version=1.0";

export default function OSD(gdkmonitor: Gdk.Monitor) {
  const { TOP, BOTTOM } = Astal.WindowAnchor;
  const speaker = Wp.get_default()?.audio.defaultSpeaker;
  const brigtness = Brightness.get_default();

  const [osdState, setOsdState] = createState<{
    type: "speaker" | "microphone" | "brightness";
    percentage: number;
    mute: boolean;
    icon: string;
  }>({
    type: "speaker",
    percentage: speaker?.volume || 0,
    mute: speaker?.mute || true,
    icon: speaker?.icon || "audio-volume-muted-symbolic",
  });

  const [isVisible, setIsVisible] = createState(false);
  let hideTimeout: ReturnType<typeof timeout> | undefined;

  speaker?.connect("notify::volume", () => {
    const volume = speaker.volume;

    setOsdState({
      type: "speaker",
      percentage: volume,
      icon: "audio-volume-high-symbolic",
    });

    setIsVisible(true);
    if (hideTimeout) hideTimeout.cancel();
    hideTimeout = timeout(1500, () => setIsVisible(false));
  });

  brigtness.connect("notify::screen", () => {
    const brightnessPercent = brigtness.screen;

    setOsdState({
      type: "brightness",
      percentage: brightnessPercent,
      icon: "penis",
    });

    setIsVisible(true);
    if (hideTimeout) hideTimeout.cancel();
    hideTimeout = timeout(1500, () => setIsVisible(false));
  });

  return (
    <window
      class="osd"
      name="osd"
      anchor={TOP}
      $={(win) => {
        const surface = win.get_surface();
        if (surface) {
          surface.set_input_region(new cairo.Region());
        }

        const revealer = win.child as Gtk.Revealer;
        isVisible.subscribe(async () => {
          const visible = isVisible.get();

          if (!visible) {
            revealer.set_reveal_child(false);
            await new Promise((r) => setTimeout(r, 150));
          }

          win.set_visible(visible);

          if (visible) {
            revealer.set_reveal_child(true);
          }
        });
      }}
    >
      <revealer
        transitionType={Gtk.RevealerTransitionType.CROSSFADE}
        transitionDuration={200}
      >
        <box spacing={8}>
          <image iconName={osdState((s) => s.icon)} />
          <Gtk.ProgressBar
            valign={Gtk.Align.CENTER}
            fraction={osdState((s) => s.percentage)}
          />
          <label
            label={osdState((s) => `${Math.floor(s.percentage * 100)}%`)}
          />
        </box>
      </revealer>
    </window>
  );
}
