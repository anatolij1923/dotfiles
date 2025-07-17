import { createBinding } from "ags";
import { execAsync } from "ags/process";
import AstalBattery01 from "gi://AstalBattery";

export default function BatteryWarnings() {
  const bat = AstalBattery01.get_default();
  const percentage = createBinding(bat, "percentage");

  const isCharging = createBinding(bat, "charging");

  const good = 85
  const low = 30;
  const critical = low / 2;

  percentage.subscribe(() => {
    const value = Math.round(percentage.get() * 100);
    const charging = isCharging.get();

    if (charging && value === good) {

      execAsync([

        "notify-send",
        "-a",
        "Battery",
        "-i",
        "battery-level-100-symbolic",
        "Battery is full",
        "You can unplug the charger"
      ])
    }

    if (charging) {
      return;
    }
    if (value === low) {
      execAsync([
        "notify-send",
        "-a",
        "Battery",
        "-u",
        "critical",
        "-i",
        "battery-caution-symbolic",
        "Battery is low",
      ]);
    }
    if (value === critical) {
      execAsync([
        "notify-send",
        "-a",
        "Battery",
        "-u",
        "critical",
        "-i",
        "battery-caution-symbolic",
        "Battery is critical",
]);
    }
  });
}
