import app from "ags/gtk4/app";
import Gtk from "gi://Gtk?version=4.0";
import Bar from "./widget/bar/Bar";
import Applauncher from "./widget/applauncher/Applauncher";
import NotificationPopups from "./widget/notifications/NotificationPopups";
import { ScreenCorners } from "./widget/bar/ScreenCorners";
import Powermenu from "./widget/powermenu/Powermenu";
import Quicksettings from "./widget/quicksettings/Quicksettings";
import OSD from "./widget/osd/OSD";
import BatteryWarnings from "./utils/batteryWarning";
import { monitorFile } from "ags/file";
import Sidebar from "./widget/sidebar/Sidebar";
import Launcher from "./widget/applauncher/Launcher";

app.start({
  icons: "assets",
  css: `${SRC}/style.css`,
  gtkTheme: "Adwaita",
  main() {
    // Monitoring styles file to immediately reapply css
    monitorFile(`${SRC}/style.css`, () => {
      console.log("[LOG] CSS reapplied");
      app.reset_css()
      app.apply_css(`${SRC}/style.css`);
    });

    app.get_monitors().forEach((monitor) => {
      // Topbar
      Bar(monitor);

      // Screencorners
      ScreenCorners(monitor);

      //Applauncher
      app.add_window(Launcher(monitor) as Gtk.Window);

      // Notification Popups
      NotificationPopups();

      // Powermenu
      app.add_window(Powermenu(monitor) as Gtk.Window);

      // Quick Settings
      app.add_window(Quicksettings(monitor) as Gtk.Window);

      // Left sidebar
      app.add_window(Sidebar(monitor) as Gtk.Window);

      // OSD;
      app.add_window(OSD(monitor) as Gtk.Window);

      // Battery warnings
      BatteryWarnings();
    });
  },
});
