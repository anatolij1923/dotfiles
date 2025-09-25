import { Astal, Gdk, Gtk } from "ags/gtk4";
import Wp from "gi://AstalWp";
import Brightness from "../../lib/brightness";
import { createState, onCleanup } from "ags";
import { timeout } from "ags/time";

const hideTime = 2000;

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

  function getVolumeIcon(volume: number, mute: boolean): string {
    if (mute || volume === 0) return "volume_off"; // или volume_mute

    if (volume < 0.33) return "volume_mute";

    if (volume < 0.66) return "volume_down";

    return "volume_up";
  }

  const volumeId = speaker?.connect("notify::volume", () => {
    const volume = speaker.volume;

    setOsdState({
      type: "speaker",
      percentage: volume,
      mute: speaker.mute,
      icon: getVolumeIcon(speaker.volume, speaker.mute),
    });

    setIsVisible(true);
    if (hideTimeout) hideTimeout.cancel();
    hideTimeout = timeout(hideTime, () => setIsVisible(false));
  });

  const muteId = speaker?.connect("notify::mute", () => {
    setOsdState({
      type: "speaker",
      percentage: speaker.volume,
      mute: speaker.mute,
      icon: speaker.mute ? "volume_off" : "volume_up",
    });

    setIsVisible(true);
    if (hideTimeout) hideTimeout.cancel();
    hideTimeout = timeout(hideTime, () => setIsVisible(false));
  });

  const brightnessId = brigtness.connect("notify::screen", () => {
    const brightnessPercent = brigtness.screen;

    setOsdState({
      type: "brightness",
      percentage: brightnessPercent,
      icon: "light_mode",
    });

    setIsVisible(true);
    if (hideTimeout) hideTimeout.cancel();
    hideTimeout = timeout(hideTime, () => setIsVisible(false));
  });

  onCleanup(() => {
    if (volumeId) speaker?.disconnect(volumeId);
    if (muteId) speaker?.disconnect(muteId);
    brigtness.disconnect(brightnessId);
  });

  return (
    <window
      gdkmonitor={gdkmonitor}
      class="osd"
      name="osd"
      layer={Astal.Layer.OVERLAY}
      anchor={TOP}
      $={(win) => {
        // const surface = win.get_surface();
        // surface?.set_input_region(new cairo.Region())
        //
        // win.connect("map", () => {
        //   win.get_surface()?.set_input_region(new cairo.Region())
        // })
        //
        //
        // if (surface) {
        //   surface.set_input_region(new cairo.Region());
        // }

        const revealer = win.child as Gtk.Revealer;
        isVisible.subscribe(async () => {
          const visible = isVisible.get();

          if (!visible) {
            revealer.set_reveal_child(false);
            await new Promise((r) => setTimeout(r, 300));
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
        transitionDuration={300}
      >
        <box class="osd-content" spacing={8}>
          <label label={osdState((s) => s.icon)} class="material-icon" />
          <Gtk.ProgressBar
            valign={Gtk.Align.CENTER}
            fraction={osdState((s) => s.percentage)}
          />
          <label
            label={osdState((s) => `${Math.floor(s.percentage * 100)}%`)}
            class="percentage-label"
          />
        </box>
      </revealer>
    </window>
  );
}
