import app from "ags/gtk4/app";
import style from "./style.scss";
import Gtk from "gi://Gtk?version=4.0";
import Bar from "./widget/bar/Bar";
import Applauncher from "./widget/applauncher/Applauncher";
import NotificationPopups from "./widget/notifications/NotificationPopups";
import { ScreenCorners } from "./widget/bar/ScreenCorners";

let applauncher: Gtk.Window;

app.start({
  css: style,
  gtkTheme: "Adwaita",
  main() {
    app.get_monitors().forEach((monitor) => {
      Bar(monitor);
      ScreenCorners(monitor);
      applauncher = Applauncher() as Gtk.Window;
      app.add_window(applauncher);
      NotificationPopups();
    });
  },
});
