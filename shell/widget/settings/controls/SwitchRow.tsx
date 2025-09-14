import { Gtk } from "ags/gtk4";
import { Setting } from "../../../lib/settings";
import { onCleanup } from "ags";

interface SwitchRowProps {
  label: string;
  setting: Setting<boolean>;
}

export function SwitchRow({ label, setting }: SwitchRowProps) {
  // Create the switch widget programmatically to get a reference.
  const switchWidget = new Gtk.Switch({
    // Set the initial state from the setting's value.
    active: setting.value,
  });

  // --- Data Flow: From UI to State ---
  // Connect to the GTK signal for when the 'active' property changes.
  // This happens when the user clicks the switch.
  const notifyId = switchWidget.connect("notify::active", () => {
    // When the switch is clicked, update our setting's value.
    // We check first to prevent potential infinite loops.
    if (setting.value !== switchWidget.active) {
      setting.value = switchWidget.active;
    }
  });

  // --- Data Flow: From State to UI ---
  // Subscribe to our setting's Accessor.
  // This handles cases where the value is changed from somewhere else.
  const unsubscribe = setting.subscribe(() => {
    // When the setting's value changes, update the switch's visual state.
    if (setting.value !== switchWidget.active) {
      switchWidget.active = setting.value;
    }
  });

  // --- Cleanup ---
  // When the component is destroyed, we must disconnect the signal
  // and unsubscribe from the accessor to prevent memory leaks.
  onCleanup(() => {
    switchWidget.disconnect(notifyId);
    unsubscribe();
  });

  return (
    <box class="setting-row" hexpand>
      <label label={label} xalign={0} hexpand />
      {/* Add the widget instance to the JSX tree */}
      {switchWidget}
    </box>
  );
}
