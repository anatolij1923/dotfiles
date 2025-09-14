import { createState, Accessor, Setter } from "ags";
import { execAsync } from "ags/process";
import Gio from "gi://Gio";
import GLib from "gi://GLib?version=2.0";

const SETTINGS_PATH = `${SRC}/settings.json`;

/**
 * Represents a single, reactive setting.
 */
export class Setting<T> {
  public readonly accessor: Accessor<T>;
  private readonly setter: Setter<T>;

  constructor(initial: T) {
    [this.accessor, this.setter] = createState(initial);
  }

  get value(): T {
    return this.accessor.get();
  }
  set value(value: T) {
    this.setter(value);
  }

  subscribe(callback: (value: T) => void): () => void {
    return this.accessor.subscribe(() => callback(this.value));
  }
}

/**
 * The central service for managing all application settings.
 */
class SettingsService {
  private _settings = new Map<string, Setting<any>>();
  private _file = Gio.File.new_for_path(SETTINGS_PATH);
  public readonly options: any = {};

  constructor() {
    // The service is initialized, but settings are not registered yet.
    // We will load the file after registration.
  }

  /**
   * Registers a new setting.
   */
  register<T>(path: string, initial: T, action?: (value: T) => void): void {
    const setting = new Setting(initial);
    this._settings.set(path, setting);

    if (action) {
      setting.subscribe(action);
    }

    // When this setting changes, save all settings to the file.
    setting.subscribe(() => this._save());

    // Dynamically build the nested `options` object
    let current = this.options;
    const parts = path.split(".");
    for (let i = 0; i < parts.length; i++) {
      const part = parts[i];
      if (i === parts.length - 1) {
        current[part] = setting;
      } else {
        current[part] = current[part] || {};
        current = current[part];
      }
    }
  }

  /**
   * Loads settings from the JSON file and applies them.
   */
  load() {
    if (!this._file.query_exists(null)) {
      print(
        `[Settings] No settings file found at ${SETTINGS_PATH}. Using defaults.`,
      );
      // Save the defaults to create the file
      this._save();
      return;
    }

    try {
      const [ok, contents] = this._file.load_contents(null);
      if (!ok) throw "Failed to load settings file.";

      const json = JSON.parse(new TextDecoder().decode(contents));
      for (const [key, value] of Object.entries(json)) {
        if (this._settings.has(key)) {
          // We use the setter to ensure that we don't trigger
          // a save operation for each setting we load.
          this._settings.get(key)!.value = value;
        }
      }
      print(`[Settings] Loaded settings from ${SETTINGS_PATH}.`);
    } catch (e) {
      logError(e, "Error loading settings:");
    }
  }

  /**
   * Saves the current state of all settings to the JSON file.
   */
  private _save() {
    const config: { [key: string]: any } = {};
    for (const [key, setting] of this._settings.entries()) {
      config[key] = setting.value;
    }

    try {
      const jsonString = JSON.stringify(config, null, 2);
      this._file.replace_contents(
        jsonString,
        null,
        false,
        Gio.FileCreateFlags.REPLACE_DESTINATION,
        null,
      );
    } catch (e) {
      logError(e, "Error saving settings:");
    }
  }
}

//  Initialization

const settings = new SettingsService();

// Register all settings
settings.register("bar.top", true, (value) => {
  print(`[Settings] Bar position: ${value ? "top" : "bottom"}`);
});
settings.register("corners.enabled", true);

settings.register("osd.top", true);
settings.register("osd.percentage", true)
settings.register("osd.margin", 24)

settings.register("hyprland.animations.enabled", true, (value) => {
  const command = `hyprctl keyword animations:enabled ${value}`;
  print(`[Settings] Running: ${command}`);
  execAsync(command).catch(logError);
});
settings.register("theme.darkMode", false, (value) => {
  const switchThemeCommand = `gsettings set org.gnome.desktop.interface color-scheme ${
    value ? "prefer-dark" : "default"
  }`;
  print("[Setting] Running: ${switchThemeCommand}");
  execAsync(switchThemeCommand).catch(logError);

  const wallpaperScriptCommand = `${GLib.get_home_dir()}/.config/hypr/scripts/wallpaper.sh`;
  print("[Setting] Running ${wallpaperScriptCommand}");
  execAsync(wallpaperScriptCommand).catch(logError);
});

// After all settings are registered, load the values from the file.
settings.load();

// Export the final `options` object
export const options = settings.options as {
  bar: {
    top: Setting<boolean>;
  };
  corners: {
    enabled: Setting<boolean>;
  };
  osd: {
    top: Setting<boolean>,
    percentage: Setting<boolean>,
    margin: Setting<number>
  }
  hyprland: {
    animations: {
      enabled: Setting<boolean>;
    };
  };
  theme: {
    darkMode: Setting<boolean>;
  };
};
