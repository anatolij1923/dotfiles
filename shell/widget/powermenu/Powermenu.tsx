import app from "ags/gtk4/app";
import Window from "../common/Window";
import { exec } from "ags/process";
import { Astal, Gtk } from "ags/gtk4";

const options = [
  {
    name: "Shutdown",
    command: "systemctl poweroff",
    icon: "power_settings_new",
  },

  {
    name: "Sleep",
    command: "systemctl suspend",
    icon: "bedtime",
  },

  {
    name: "Restart",
    command: "systemctl reboot",
    icon: "refresh",
  },
  {
    name: "Logout",
    command: "hyprctl dispatch exit",
    icon: "exit_to_app",
  },
];

export default function Powermenu() {
  return (
    <Window
      name="Powermenu"
      keymode={Astal.Keymode.EXCLUSIVE}
      class="powermenu"
    >
      <box class="powermenu-content">
        {options.map((option) => (
          <button
            onClicked={() => {
              exec(option.command);
              app.toggle_window("Powermenu");
            }}
          >
            <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
              <label label={option.icon} class="material-icon" />
              <label label={option.name} class="button-name" />
            </box>
          </button>
        ))}
      </box>
    </Window>
  );
}
