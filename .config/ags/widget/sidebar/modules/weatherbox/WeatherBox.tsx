import GLib from "gi://GLib?version=2.0";
import { distro } from "../../../../utils/util";

export default function WeatherBox() {
  return <box>
    <label label={distro.id} />
    weather - +20C у меня в жопе</box>;
}
