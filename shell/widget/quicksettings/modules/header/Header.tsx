import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";
import GLib from "gi://GLib?version=2.0";
import { getUptime } from "../../../../utils/uptime";
import app from "ags/gtk4/app";

const userName = GLib.get_user_name();

const uptime = createPoll("", 5000, async () => await getUptime());

const imageDir = GLib.get_user_special_dir(
  GLib.UserDirectory.DIRECTORY_PICTURES,
);
const userPic = GLib.build_filenamev([imageDir, "pic.png"]);

function fileExists(path: string) {
  return GLib.file_test(path, GLib.FileTest.EXISTS);
}

export default function Header() {
  return (
    <box class="header">
      <box class="user-info" spacing={16}>
        <box
          class="user-pic"
          overflow={Gtk.Overflow.HIDDEN}
          visible={fileExists(userPic)}
        >
          <image file={userPic} pixelSize={64} />
        </box>
        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={4}
          valign={Gtk.Align.CENTER}
        >
          <label label={userName} class="username" xalign={0} />
          <box class="uptime">
            <label label="Uptime: " />
            <label label={uptime} />
          </box>
        </box>
      </box>
      <box hexpand />
      <box class="buttons">
        <button
          class="power-button"
          onClicked={() => {
            app.toggle_window("powermenu");
            app.toggle_window("quicksettings");
          }}
        >
          <label label="power_settings_new" class="material-icon" />
        </button>
      </box>
    </box>
  );
}
