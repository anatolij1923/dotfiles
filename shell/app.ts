import app from "ags/gtk4/app";
import style from "./style.scss";
import Gtk from "gi://Gtk?version=4.0";
import Bar from "./widget/bar/Bar";
import Applauncher from "./widget/applauncher/Applauncher";
import NotificationPopups from "./widget/notifications/NotificationPopups";
import { ScreenCorners } from "./widget/bar/ScreenCorners";
import Powermenu from "./widget/powermenu/Powermenu";
import Quicksettings from "./widget/quicksettings/Quicksettings";
import OSD from "./widget/osd/OSD";
import BatteryWarnings from "./utils/batteryWarning";

app.start({
  icons: "assets",
  css: style,
  gtkTheme: "Adwaita",
  main() {
    app.get_monitors().forEach((monitor) => {
      // Topbar
      Bar(monitor);

      // Screencorners
      ScreenCorners(monitor);

      // Applauncher
      app.add_window(Applauncher() as Gtk.Window);

      // Notification Popups
      NotificationPopups();

      // Powermenu
      app.add_window(Powermenu(monitor) as Gtk.Window);

      // Quick Settings
      app.add_window(Quicksettings(monitor) as Gtk.Window);

      // On Screen Display
      // OSD(monitor);
      app.add_window(OSD(monitor) as Gtk.Window);

      //Battery warnings
      BatteryWarnings();

      // Screendim(monitor);
      //
    });
  },
});
