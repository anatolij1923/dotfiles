import QtQuick
import qs.services
import Quickshell.Services.UPower

QuickToggle {
    checked: PowerProfiles.profile == PowerProfile.Performance ? true : false

    icon: switch (PowerProfiles.profile) {
    case PowerProfile.PowerSaver:
        return "energy_savings_leaf";
    case PowerProfile.Balanced:
        return "balance";
    case PowerProfile.Performance:
        return "local_fire_department";
    }

    onClicked: () => {
        if (PowerProfiles.hasPerformanceProfile) {
            switch (PowerProfiles.profile) {
            case PowerProfile.PowerSaver:
                PowerProfiles.profile = PowerProfile.Balanced;
                break;
            case PowerProfile.Balanced:
                PowerProfiles.profile = PowerProfile.Performance;
                break;
            case PowerProfile.Performance:
                PowerProfiles.profile = PowerProfile.PowerSaver;
                break;
            }
        } else {
            PowerProfiles.profile = PowerProfiles.profile == PowerProfile.Balanced ? PowerProfile.PowerSaver : PowerProfile.Balanced;
        }
    }
    tooltipText: Translation.tr("quicksettings.toggles.power_profiles")
}
