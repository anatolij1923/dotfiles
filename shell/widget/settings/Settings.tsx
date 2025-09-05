import { Gtk } from "ags/gtk4";
import Adw from "gi://Adw?version=1";
import SettingsButton from "./SettingsButton";
import Appearance from "./pages/Appearance";
import { createState } from "ags";
import Test from "./pages/Test";
import About from "./pages/About";

const [settingsPage, setSettingsPage] = createState("appearance");

function ButtonsRow() {
  return (
    <box
      class="buttons-row"
      orientation={Gtk.Orientation.VERTICAL}
      halign={Gtk.Align.START}
      hexpand={false}
      spacing={16}
    >
      <box class="header">
        <label label="Settings" xalign={0} hexpand />
        <button class="fold">
          <label label="menu" class="material-icon" />
        </button>
      </box>
      <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
        <SettingsButton
          icon="palette"
          label="Appearance"
          onClicked={() => {
            setSettingsPage("appearance");
            console.log("appearance");
          }}
          connection={settingsPage}
          pageName="appearance"
        />
        <SettingsButton
          icon="info"
          label="About"
          onClicked={() => {
            setSettingsPage("about");
            console.log("test");
          }}
          connection={settingsPage}
          pageName="about"
        />
      </box>
    </box>
  );
}

function Page() {
  return (
    <box>
      <Gtk.Stack
        visibleChildName={settingsPage}
        transitionType={Gtk.StackTransitionType.CROSSFADE}
      >
        <box $type="named" name="appearance">
          <Appearance />
        </box>
        <box $type="named" name="about">
          <About />
        </box>
      </Gtk.Stack>
    </box>
  );
}

export default function Settings() {
  return (
    <Gtk.Window name="settings" title="Settings" hideOnClose={true}>
      <box class="settings">
        <ButtonsRow />
        <Page />
      </box>
    </Gtk.Window>
  );
}
