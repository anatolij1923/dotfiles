import { Gtk } from "ags/gtk4";
import { createState, Accessor } from "ags";

interface SettingsButtonProps {
  icon: string;
  label: string;
  setup?: (self: Gtk.Widget) => void; // Make setup optional
  onClicked: () => void;
  tooltip?: string;
  connection: Accessor<string>; // New prop for active page connection
  pageName: string; // New prop for the button's page name
}

export default function SettingsButton({
  icon,
  label,
  setup: originalSetup, // Rename original setup
  onClicked,
  tooltip,
  connection,
  pageName,
}: SettingsButtonProps) {
  const [cssClasses, setCssClasses] = createState<string[]>([
    "settings-button",
  ]);

  const setup = (self: Gtk.Widget) => {
    const updateClasses = (activePage: string) => {
      const newClasses = ["settings-button"];
      if (activePage === pageName) {
        newClasses.push("active");
      }
      setCssClasses(newClasses);
    };

    const unsubscribe = connection.subscribe(() => {
      updateClasses(connection.get());
    });
    updateClasses(connection.get()); // Set initial state

    self.connect("destroy", () => {
      unsubscribe();
    });

    if (originalSetup) originalSetup(self);
  };

  return (
    <button
      onClicked={onClicked}
      tooltipText={tooltip}
      $={setup}
      cssClasses={cssClasses}
    >
      <box spacing={16}>
        <label label={icon} class="material-icon" />
        <label label={label} />
      </box>
    </button>
  );
}
