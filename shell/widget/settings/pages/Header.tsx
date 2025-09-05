import { Gtk } from "ags/gtk4";

interface HeaderProps {
  title: string;
}

export function Header({ title }: HeaderProps) {
  return (
    <box class="header" valign={Gtk.Align.START} hexpand>
      <label label={title} hexpand halign={Gtk.Align.CENTER} />
    </box>
  );
}
