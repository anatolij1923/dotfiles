import { Gtk } from "ags/gtk4";
import { Header } from "./Header";

interface SettingsPageProps {
  headerTitle: string;
  children?: any;
  className: string;
}

export default function SettingsPage({
  headerTitle,
  children,
  className,
}: SettingsPageProps) {
  return (
    <box class={className} hexpand orientation={Gtk.Orientation.VERTICAL}>
      <Header title={headerTitle} />
      <Gtk.ScrolledWindow hexpand vexpand>
        <box
          class="page-content"
          orientation={Gtk.Orientation.VERTICAL}
          spacing={16}
        >
          {children}
        </box>
      </Gtk.ScrolledWindow>
    </box>
  );
}
