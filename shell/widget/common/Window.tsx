import { Astal, Gtk, Gdk } from "ags/gtk4";
import Graphene from "gi://Graphene";
import type { WindowProps } from "astal/widget";
import app from "ags/gtk4/app";

interface CommonWindowProps extends WindowProps {
  name: string;
  namespace: string;
  gdkmonitor?: Gdk.Monitor;
  anchor?: Astal.WindowAnchor;
  exclusivity?: Astal.Exclusivity;
  keymode?: Astal.Keymode;
  visible?: boolean;
  class: string;
  onKey?: (
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number,
  ) => void;
  onClick?: (_e: Gtk.GestureClick, _: number, x: number, y: number) => void;
  onVisibilityChange?: (visible: boolean) => void;
  children?: any;
  contentValign?: Gtk.Align;
  contentHalign?: Gtk.Align;
  contentVexpand?: boolean;
  contentHexpand?: boolean;
}

export default function Window({
  name,
  namespace,
  gdkmonitor,
  anchor,
  exclusivity,
  keymode,
  visible,
  onKey,
  onClick,
  onVisibilityChange,
  children,
  contentValign,
  contentHalign,
  contentVexpand,
  contentHexpand,
  ...rest
}: CommonWindowProps) {
  let win: Astal.Window;
  let contentbox: Gtk.Box;

  function handleKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number,
  ) {
    if (keyval === Gdk.KEY_Escape) {
      win.visible = false;
    }
    onKey?.(_e, keyval, _, mod);
  }

  function handleClick(_e: Gtk.GestureClick, _: number, x: number, y: number) {
    const [, rect] = contentbox.compute_bounds(win);
    const position = new Graphene.Point({ x, y });

    if (!rect.contains_point(position)) {
      win.visible = false;
      return true;
    }
    onClick?.(_e, _, x, y);
  }

  return (
    <window
      application={app}
      $={(ref) => (win = ref)}
      name={name}
      gdkmonitor={gdkmonitor}
      anchor={anchor}
      exclusivity={exclusivity}
      keymode={keymode}
      layer={Astal.Layer.OVERLAY}
      margin={16}
      onNotifyVisible={({ visible }) => {
        if (visible) {
          contentbox.grab_focus();
        }
        onVisibilityChange?.(visible);
      }}
      {...rest}
    >
      <Gtk.EventControllerKey onKeyPressed={handleKey} />
      <Gtk.GestureClick onPressed={handleClick} />
      <box
        $={(ref) => (contentbox = ref)}
        name={`${name}-content`}
        valign={contentValign ?? Gtk.Align.CENTER}
        halign={contentHalign ?? Gtk.Align.CENTER}
        vexpand={contentVexpand ?? false}
        hexpand={contentHexpand ?? false}
        orientation={Gtk.Orientation.VERTICAL}
      >
        {children}
      </box>
    </window>
  );
}
