import Wp from "gi://AstalWp";
import Brightness from "../../../../lib/brightness";
import { Gtk } from "ags/gtk4";
import { createBinding } from "ags";

export default function Sliders() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker;
  const brightness = Brightness.get_default();

  return (
    <box class="sliders" orientation={Gtk.Orientation.VERTICAL}>
      <box>
        <label label="music_note" class="material-icon" />
        <slider
          value={createBinding(speaker, "volume")}
          onChangeValue={(self) => {
            speaker.volume = self.value;
          }}
          hexpand
        />
      </box>

      <box>
        <label label="brightness_6" class="material-icon" />
        <slider
          value={createBinding(brightness, "screen")}
          onChangeValue={(self) => {
            brightness.screen = self.value;
          }}
          hexpand
        />
      </box>
    </box>
  );
}
