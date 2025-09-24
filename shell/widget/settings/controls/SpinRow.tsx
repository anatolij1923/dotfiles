import { Gtk } from "ags/gtk4";
import { Setting } from "../../../lib/settings";
import { onCleanup } from "ags";

interface SpinRowProps {
  label: string;
  setting: Setting<number>;
  min: number;
  max: number;
  step?: number;
}

export default function SpinRow({
  label,
  setting,
  min,
  max,
  step = 1,
}: SpinRowProps) {
  const spin = new Gtk.SpinButton({
    adjustment: new Gtk.Adjustment({
      value: setting.value,
      lower: min,
      upper: max,
      step_increment: step,
    }),
    cssClasses: ["spin-button"],
  });

  spin.value = setting.value;

  spin.connect("value-changed", () => {
    setting.value = spin.value;
  });

  const unsubscribe = setting.subscribe(() => {
    if (spin.value !== setting.value) spin.value = setting.value;
  });

  onCleanup(() => unsubscribe());

  return (
    <box class="spin-row">
      <label label={label} />
      <box hexpand />
      {spin}
    </box>
  );
}
