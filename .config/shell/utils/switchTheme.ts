import { execAsync } from "ags/process";
import GLib from "gi://GLib?version=2.0";

export function switchTheme() {
  const current = GLib.spawn_command_line_sync(
    "gsettings get org.gnome.desktop.interface color-scheme"
  )[1].toString().trim();

  const next = current === "'prefer-dark'" ? "default" : "prefer-dark";

  execAsync([
    "gsettings",
    "set",
    "org.gnome.desktop.interface",
    "color-scheme",
    next,
  ]);
}
