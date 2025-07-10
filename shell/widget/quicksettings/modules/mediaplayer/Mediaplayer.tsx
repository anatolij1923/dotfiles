import { bind, timeout, Variable } from "astal";
import Mpris from "gi://AstalMpris";
import icons from "../../../utils/icons";
import { Gtk } from "astal/gtk4";
import Pango from "gi://Pango?version=1.0";

function lengthStr(length: number) {
  const min = Math.floor(length / 60);
  const sec = Math.floor(length % 60);
  const sec0 = sec < 10 ? "0" : "";
  return `${min}:${sec0}${sec}`;
}

function MediaPlayer({ player }: { player: Mpris.Player }) {
  let lastPlayingPositionString = "0:00 / 0:00"; // Store the last playing position string

  if (!player) {
    return <box />;
  }

  const trackLengthBinding = Variable.derive(
    [bind(player, "position"), bind(player, "playbackStatus")],
    (p: number, status: Mpris.PlaybackStatus) => {
      const formattedLength = `${lengthStr(p)} / ${lengthStr(player.length)}`;
      if (status === Mpris.PlaybackStatus.PLAYING) {
        lastPlayingPositionString = formattedLength;
        return formattedLength;
      } else {
        return lastPlayingPositionString;
      }
    }
  )();

  const title = bind(player, "title").as((t) => t || "Unknown Track");
  const artist = bind(player, "artist").as((t) => t || "Unknown Artist");
  const cover = bind(player, "coverArt");
  const playIcon = bind(player, "playbackStatus").as((s) =>
    s === Mpris.PlaybackStatus.PLAYING
      ? icons.media.playing
      : icons.media.paused
  );
  const position = bind(player, "position").as((p) =>
    player.length > 0 ? p / player.length : 0
  );

  return (
    <box cssClasses={["MediaPlayer"]} hexpand>
      <box cssClasses={["Cover"]}>
        <image
          overflow={Gtk.Overflow.HIDDEN}
          pixelSize={90}
          file={cover}
          cssClasses={["CoverArt"]}
        />
      </box>

      <box vertical>
        <box hexpand>
          <box vertical cssClasses={["TrackInfo"]} hexpand>
            <box>
              <label
                cssClasses={["TrackName"]}
                label={title}
                ellipsize={Pango.EllipsizeMode.END}
                maxWidthChars={20}
              />
            </box>
            <box>
              <label label={artist} cssClasses={["ArtistName"]} />
            </box>
          </box>
        </box>
        <box>
          <box cssClasses={["Controls"]}>
            <box hexpand>
              <button onClicked={() => player.previous()}>
                <image iconName={icons.media.prev} />
              </button>
              <button onClicked={() => player.next()}>
                <image iconName={icons.media.next} />
              </button>
            </box>
            <box cssClasses={["track-length"]}>
              <label
                label={trackLengthBinding.as((s: string) => s)} // Bind to the derived variable's value
              />
            </box>
            <box>
              <button
                halign={Gtk.Align.END}
                valign={Gtk.Align.CENTER}
                onClicked={() => player.play_pause()}
                visible={bind(player, "canControl")}
              >
                <image iconName={playIcon} />
              </button>
            </box>
          </box>
        </box>
      </box>
    </box>
  );
}

export default function PlayerWidget() {
  const mpris = Mpris.get_default();
  return (
    <box>
      {bind(mpris, "players").as((players) => (
        <MediaPlayer player={players[0]} />
      ))}
    </box>
  );
}
