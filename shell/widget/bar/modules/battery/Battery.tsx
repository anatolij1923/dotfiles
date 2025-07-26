import { createBinding, createComputed } from "ags";
import AstalBattery from "gi://AstalBattery?version=0.1";
import { formatTime } from "../../../../utils/formatTime";
import { Gtk } from "ags/gtk4";

export default function Battery() {
  const battery = AstalBattery.get_default();

  const isCharging = createBinding(battery, "charging");
  const percent = createBinding(battery, "percentage");
  const timeToFull = createBinding(battery, "time_to_full");
  const timeToEmpty = createBinding(battery, "time_to_empty");
  const energyRate = createBinding(battery, "energy_rate");

  function updateTooltip(
    percent: number,
    isCharging: boolean,
    timeToEmpty: number,
    timeToFull: number,
    energyRate: number
  ) {
    return [
      `${
        isCharging
          ? Math.floor(percent * 100) === 100
            ? "Full"
            : `Time to full: ${formatTime(timeToFull)}`
          : `Time to empty: ${formatTime(timeToEmpty)}`
      }`,
      `${energyRate}W`,
    ].join(" - ");
  }

  const tooltip = createComputed(
    [percent, isCharging, timeToEmpty, timeToFull, energyRate],
    updateTooltip
  );

  const formattedPercent = percent.as((p) => `${Math.floor(p * 100)}`);

  return (
    <box class="battery" tooltipMarkup={tooltip}>
      {/* <overlay>
        <levelbar
          value={createBinding(battery, "percentage")}
          widthRequest={50}
          class={isCharging.as((charging) => (charging ? "charging" : ""))}
        />
        <label label={formattedPercent} $type="overlay" />
      </overlay> */}

      <overlay>
        <Gtk.ProgressBar
          fraction={createBinding(battery, "percentage")}
          halign={Gtk.Align.CENTER}
          widthRequest={50}
          class={isCharging.as((charging) => (charging ? "charging" : ""))}
          valign={Gtk.Align.CENTER}
        />
        <label label={formattedPercent} $type="overlay" />
      </overlay>
    </box>
  );
}
