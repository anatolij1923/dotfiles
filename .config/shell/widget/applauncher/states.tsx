import { createState } from "ags";
import AstalApps from "gi://AstalApps?version=0.1";
import { Command } from "./Commands";

export const [appsList, setAppsList] = createState<AstalApps.Application[]>([]);
export const [showAppsList, setShowAppsList] = createState(false);
export const [commands, setCommands] = createState<Command[]>([]);

