import app from "ags/gtk4/app";
import AstalApps from "gi://AstalApps?version=0.1";
import GLib from "gi://GLib?version=2.0";

export function range(max: number) {
  return Array.from({ length: max + 1 }, (_, i) => i);
}

export function hide(window: string) {
  app.get_window(window)?.hide()
}

export const HOME = GLib.getenv("HOME")

export const distro = {
  id: GLib.get_os_info("ID"),
  name: GLib.get_os_info("NAME")
}

export function launchApplication(app?: AstalApps.Application) {
  if (app) {
    app.launch();
    hide("launcher");
  }
}

