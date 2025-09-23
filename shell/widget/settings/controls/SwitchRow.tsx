import { Gtk } from "ags/gtk4";
import { Setting } from "../../../lib/settings";
import { Accessor, onCleanup } from "ags";

interface SwitchRowProps {
  label: string;
  setting?: Setting<boolean>;
  value?: boolean | Accessor<boolean>;
  onChange?: (v: boolean) => void;
}

function isAccessor<T = any>(v: any): v is Accessor<T> {
  return v && typeof v.get === "function" && typeof v.subscribe === "function";
}

export function SwitchRow({ label, setting, value, onChange }: SwitchRowProps) {
  const getCurrent = (): boolean => {
    if (setting) return setting.value;
    if (isAccessor<boolean>(value)) return value.get();
    return typeof value === "boolean" ? value : false;
  };

  const switchWidget = new Gtk.Switch({
    active: getCurrent(),
  });

  const notifyId = switchWidget.connect("notify::active", () => {
    const active = switchWidget.active;

    if (setting) {
      if (setting.value !== active) setting.value = active;
      return;
    }

    if (isAccessor<boolean>(value)) {
      const accessorAny: any = value;
      if (typeof accessorAny.set === "function") {
        accessorAny.set(active);
      } else if (onChange) {
        onChange(active);
      }
      return;
    }

    if (onChange) onChange(active);
  });

  let unsubscribe: (() => void) | undefined;
  if (setting) {
    unsubscribe = setting.subscribe(() => {
      if (switchWidget.active !== setting.value)
        switchWidget.active = setting.value;
    });
  } else if (isAccessor<boolean>(value)) {
    unsubscribe = value.subscribe((v?: boolean) => {
      const newVal = typeof v === "boolean" ? v : value.get();
      if (switchWidget.active !== newVal) switchWidget.active = newVal;
    });
  }

  onCleanup(() => {
    switchWidget.disconnect(notifyId);
    if (unsubscribe) unsubscribe();
  });

  return (
    <box class="switch-row" hexpand>
      <label label={label} xalign={0} hexpand />
      {switchWidget}
    </box>
  );
}
