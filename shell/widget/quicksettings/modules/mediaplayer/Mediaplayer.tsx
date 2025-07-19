import { createBinding, For } from "ags";
import { Gtk } from "ags/gtk4";
import AstalApps01 from "gi://AstalApps";
import Mpris from "gi://AstalMpris";
import Pango from "gi://Pango?version=1.0";

export default function Mediaplayer() {
  const mpris = Mpris.get_default();
  const players = createBinding(mpris, "players");
  const apps = new AstalApps01.Apps();

  return (
    <box orientation={Gtk.Orientation.VERTICAL}>
      <For each={players}>
        {(player) => (
          <box class="mediaplayer" spacing={16}>
            <box overflow={Gtk.Overflow.HIDDEN} class="cover-art">
              <image file={createBinding(player, "coverArt")} pixelSize={96} />
            </box>

            <box orientation={Gtk.Orientation.VERTICAL}>
              <box class="info" hexpand>
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

              <box>
                <Gtk.ProgressBar
                  fraction={createBinding(player, "position")}
                  hexpand
                />
              </box>

              <box class="buttons" halign={Gtk.Align.CENTER} spacing={16}>
                <button onClicked={() => player.previous()}>
                  <label label="skip_previous" class="material-icon" />
                </button>
                <button onClicked={() => player.play_pause()}>
                  <label
                    label={createBinding(
                      player,
                      "playbackStatus"
                    )((v) => (v ? "play_arrow" : "pause"))}
                    class="material-icon"
                  />
                </button>
                <button onClicked={() => player.next()}>
                  <label label="skip_next" class="material-icon" />
                </button>
              </box>
            </box>
          </box>
        )}
      </For>
    </box>
  );
}
