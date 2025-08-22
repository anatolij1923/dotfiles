import { createBinding, createState, For } from "ags";
import { Gtk } from "ags/gtk4";
import Notifd from "gi://AstalNotifd";
import Notification from "../../../notifications/Notification";

const notifd = Notifd.get_default();
const notifications = createBinding(notifd, "notifications");

function NotificationScrolledWindow() {
  return (
    <Gtk.ScrolledWindow>
      <box orientation={Gtk.Orientation.VERTICAL}>
        <For each={notifications}>
          {(n) => <Notification notification={n} showActions={true} />}
        </For>
        <box
          orientation={Gtk.Orientation.VERTICAL}
          valign={Gtk.Align.CENTER}
          halign={Gtk.Align.CENTER}
          vexpand
          spacing={8}
          hexpand
          visible={notifications((n) => n.length === 0)}
        >
          <Gtk.Image
            iconName="mail-unread-symbolic"
            // iconSize={Gtk.IconSize.LARGE}
            pixelSize={48}
          />
          <Gtk.Label label="You have no notifications" />
        </box>
      </box>
    </Gtk.ScrolledWindow>
  );
}

function ClearButton() {
  return (
    <button
      class="clear-button"
      onClicked={() => {
        notifd.notifications.forEach((n) => n.dismiss());
      }}
      sensitive={notifications((n) => n.length > 0)}
    >
      <box spacing={8}>
        <label label="clear_all" class="material-icon" />
        <label label="Clear" />
      </box>
    </button>
  );
}

function NotificationCount() {
  return (
    <box>
      <label label={notifications((n) => `${n.length} Notifications`)} />
    </box>
  );
}

export default function NotificationWindow() {
  return (
    <box
      name={"notifications"}
      class="notification-window"
      orientation={Gtk.Orientation.VERTICAL}
      vexpand
      hexpand
    >
      <box class="header">
        {/* <NotificationCount /> */}
        <label label="Notifications" />
        <box hexpand />
        <ClearButton />
      </box>
      <box vexpand>
        <NotificationScrolledWindow />
      </box>
    </box>
  );
}
