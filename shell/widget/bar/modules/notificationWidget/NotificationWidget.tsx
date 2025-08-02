import { createBinding } from "ags";
import Notifd from "gi://AstalNotifd";

export default function NotificationWidget() {
  const notifd = Notifd.get_default();
  const notifications = createBinding(notifd, "notifications");

  const dnd = createBinding(notifd, "dont_disturb");
  const icon = dnd((v) => {
    if (v) {
      return "notifications_off";
    }
    return "notifications";
  });

  return (
    <box class="notification-widget" spacing={2}>
      <label label={icon} class="material-icon" />
      <label label={notifications((n) => `${n.length}`)} />
    </box>
  );
}
