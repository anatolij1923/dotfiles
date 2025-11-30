import { createBinding, createComputed, For } from "ags";
import { Gtk } from "ags/gtk4";
import AstalApps01 from "gi://AstalApps";
import Mpris from "gi://AstalMpris";
import Pango from "gi://Pango?version=1.0";

function formatTime(seconds: number): string {
  if (isNaN(seconds) || seconds < 0) return "0:00";
  const min = Math.floor(seconds / 60);
  const sec = Math.floor(seconds % 60);
  return `${min}:${sec < 10 ? "0" : ""}${sec}`;
}

export default function Mediaplayer() {
  const mpris = Mpris.get_default();
  const players = createBinding(mpris, "players");
  const apps = new AstalApps01.Apps();

  // in case if i want to render only spotify players
  const spotifyPlayers = createComputed([players], (ps) => {
    return ps.filter((p) => p.identity === "Spotify");
  });

  return (
    <box orientation={Gtk.Orientation.VERTICAL}>
      <For each={spotifyPlayers}>
        {(player) => {
          const position = createBinding(player, "position");
          const length = createBinding(player, "length");
          const progress = createComputed([position, length], (pos, len) => {
            if (typeof pos === "number" && typeof len === "number" && len > 0) {
              return pos / len;
            }
            return 0;
          });
          return (
            <box class="mediaplayer" spacing={16}>
              <box overflow={Gtk.Overflow.HIDDEN} class="cover-art">
                <image
                  file={createBinding(player, "coverArt")}
                  pixelSize={128}
                />
              </box>

              <box orientation={Gtk.Orientation.VERTICAL} hexpand>
                <box class="info">
                  <box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
                    <label
                      ellipsize={Pango.EllipsizeMode.END}
                      maxWidthChars={20}
                      xalign={0}
                      label={createBinding(player, "title")}
                      class="track"
                    />
                    <label
                      xalign={0}
                      maxWidthChars={15}
                      ellipsize={Pango.EllipsizeMode.END}
                      label={createBinding(player, "artist")}
                      class="artist"
                    />
                  </box>

                  <box hexpand></box>
                  <box>
                    {(() => {
                      const [app] = apps.exact_query(player.entry);
                      return (
                        <image
                          visible={!!app.iconName}
                          iconName={app?.iconName}
                          pixelSize={32}
                        />
                      );
                    })()}
                  </box>
                </box>

                <box
                  spacing={4}
                  orientation={Gtk.Orientation.VERTICAL}
                  class="progress"
                >
                  <Gtk.ProgressBar
                    fraction={progress}
                    hexpand
                    valign={Gtk.Align.CENTER}
                  />
                  <box>
                    <label
                      xalign={0}
                      hexpand
                      label={position((v) => `${formatTime(v)}`)}
                    />
                    <label label={length((v) => `${formatTime(v)}`)} />
                  </box>
                </box>

                <box class="buttons" halign={Gtk.Align.CENTER} spacing={16}>
                  <button onClicked={() => player.previous()}>
                    <label label="skip_previous" class="material-icon" />
                  </button>
                  <button onClicked={() => player.play_pause()}>
                    <label
                      label={createBinding(player, "playbackStatus").as((s) =>
                        s === Mpris.PlaybackStatus.PLAYING
                          ? "pause"
                          : "play_arrow"
                      )}
                      class="material-icon"
                    />
                  </button>
                  <button onClicked={() => player.next()}>
                    <label label="skip_next" class="material-icon" />
                  </button>
                </box>
              </box>
            </box>
          );
        }}
      </For>
    </box>
  );
}
