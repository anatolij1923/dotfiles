import Wp from "gi://AstalWp";
import Brightness from "../../../../lib/brightness";
import { Gtk } from "ags/gtk4";
import { createBinding, createState, For } from "ags";
import Pango from "gi://Pango?version=1.0";

// TODO: move audio mixer to antoher component
function AudioMixer() {
  const wp = Wp.get_default();
  const audio = wp.audio;
  const streams = createBinding(audio, "streams");

  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="audio-mixer" spacing={8}>
      <For each={streams}>
        {(stream) => (
          <box orientation={Gtk.Orientation.VERTICAL}>
            <label
              class="stream-name"
              label={stream.name}
              ellipsize={Pango.EllipsizeMode.END}
              maxWidthChars={35}
              halign={Gtk.Align.START}
            />
            <box>
              <slider
                value={stream.volume}
                onChangeValue={(self) => {
                  stream.volume = self.value;
                }}
                hexpand
              />

              <button
                class={createBinding(stream, "mute").as((v) =>
                  v ? "mute-button active" : "mute-button",
                )}
                onClicked={() => {
                  stream.mute = !stream.mute;
                }}
              >
                <label
                  label={createBinding(
                    stream,
                    "mute",
                  )((v) => (v ? "volume_off" : "volume_up"))}
                  class="material-icon"
                />
              </button>
            </box>
          </box>
        )}
      </For>
    </box>
  );
}

export default function Sliders() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker;
  const brightness = Brightness.get_default();
  const [isExpanded, setIsExpanded] = createState(false);

  return (
    <box class="sliders" orientation={Gtk.Orientation.VERTICAL}>
      <box spacing={8}>
        <label label="light_mode" class="material-icon" />
        <slider
          value={createBinding(brightness, "screen")}
          onChangeValue={(self) => {
            brightness.screen = self.value;
          }}
          hexpand
        />
      </box>
      <box spacing={8} orientation={Gtk.Orientation.VERTICAL}>
        <box spacing={8}>
          <label label="music_note" class="material-icon" />
          <slider
            value={createBinding(speaker, "volume")}
            onChangeValue={(self) => {
              speaker.volume = self.value;
            }}
            hexpand
          />
          <button
            class="expand-button"
            onClicked={() => setIsExpanded(!isExpanded.get())}
          >
            <label
              label={isExpanded(() =>
                isExpanded.get() ? "keyboard_arrow_up" : "keyboard_arrow_down",
              )}
              class="material-icon"
            />
          </button>
        </box>
        <revealer
          revealChild={isExpanded}
          transitionDuration={300}
          transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
        >
          <AudioMixer />
        </revealer>
      </box>
    </box>
  );
}
