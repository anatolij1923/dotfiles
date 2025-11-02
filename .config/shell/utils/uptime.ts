import { execAsync } from "ags/process";

export const getUptime = async () => {
  try {
    await execAsync(["bash", "-c", "uptime -p"]);
    return execAsync([
      "bash",
      "-c",
      `uptime -p | sed -e 's/...//;s/ day\\| days/d/;s/ hour\\| hours/h/;s/ minute\\| minutes/m/;s/,[^,]*//2'`,
    ]);
  } catch {
    return execAsync(["bash", "-c", "uptime -p"]).then((output) => {
      const regex = /up\s+((\d+)\s+days?,\s+)?((\d+):(\d+)),/;
      const match = regex.exec(output)

      if (match) {
        const days = match[2] ? parseInt(match[2]) : 0
        const hours = match[4] ? parseInt(match[4]) : 0
        const minutes = match[5] ? parseInt(match[5]) : 0

        let uptime = ""

        uptime += `${days} d`
        uptime += `${hours} h`
        uptime += `${minutes} m`

        return uptime
      }
    });
  } 
};

