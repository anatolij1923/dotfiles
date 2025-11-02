import GObject, { register, property } from "ags/gobject";
import { monitorFile, readFileAsync } from "ags/file";
import { exec, execAsync } from "ags/process";

// Function to get numeric output from brightnessctl
const getBrightnessValue = (args: string): number => {
  try {
    return Number(exec(`brightnessctl ${args}`));
  } catch (e) {
    console.error(`Error executing brightnessctl ${args}:`, e);
    return 0; // Default to 0 on error
  }
};

// Dynamically find the backlight model
const getBacklightModel = (): string => {
  try {
    return exec(`bash -c "ls -w1 /sys/class/backlight | head -1"`).trim();
  } catch (e) {
    console.error("Error getting backlight model:", e);
    return ""; // Return empty string on error
  }
};

const backlightModel = getBacklightModel();

@register({ GTypeName: "Brightness" })
export default class Brightness extends GObject.Object {
  static instance: Brightness;

  static get_default(): Brightness {
    if (!Brightness.instance) {
      Brightness.instance = new Brightness();
    }
    return Brightness.instance;
  }

  #maxBrightness: number;
  #currentBrightness: number;
  #brightnessFile: string;

  get screen(): number {
    return this.#currentBrightness;
  }

  set screen(percent: number) {
    // Clamp the value between 0 and 1
    percent = Math.max(0, Math.min(1, percent));

    if (this.#currentBrightness === percent) {
      return;
    }

    const newValue = Math.floor(percent * 100); // brightnessctl uses percentage

    execAsync(`brightnessctl set ${newValue}% -q`)
      .then(() => {
        this.#currentBrightness = percent;
        this.notify("screen");
      })
      .catch((e) => {
        console.error("Error setting brightness:", e);
      });
  }

  constructor() {
    super();

    if (!backlightModel) {
      console.error(
        "No backlight model found. Brightness control may not work."
      );
      this.#maxBrightness = 1;
      this.#currentBrightness = 0;
      this.#brightnessFile = "";
      return;
    }

    this.#brightnessFile = `/sys/class/backlight/${backlightModel}/brightness`;

    // Initialize max brightness and current brightness
    this.#maxBrightness = getBrightnessValue("max");
    const rawCurrentBrightness = getBrightnessValue("get");
    this.#currentBrightness = rawCurrentBrightness / (this.#maxBrightness || 1);

    // Monitor the brightness file for external changes
    monitorFile(this.#brightnessFile, async (file) => {
      try {
        const content = await readFileAsync(file);
        const newRawBrightness = Number(content.trim());
        const newPercent = newRawBrightness / (this.#maxBrightness || 1);

        if (this.#currentBrightness !== newPercent) {
          this.#currentBrightness = newPercent;
          this.notify("screen");
        }
      } catch (e) {
        console.error("Error reading brightness file:", e);
      }
    });
  }
}

enum Property {
  SCREEN = 1,
}

Brightness.install_property(
  Property.SCREEN,
  GObject.ParamSpec.double(
    "screen",
    "screen",
    "screen",
    GObject.ParamFlags.READWRITE,
    0,
    1,
    0
  )
);
