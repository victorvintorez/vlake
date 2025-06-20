{ config, lib, ... }:
let
  cfg = config.vlake.hardware.power;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.hardware.power = {
    enable = mkEnableOption "Enable Battery/Power Management";
  };

  config = mkIf cfg.enable {
    powerManagment.enable = true;

    services = {
      # Enable Upower for battery monitoring
      upower = {
        enable = true;
        usePercentageForPolicy = true;
        percentageLow = 15;
        percentageCritical = 10;
        percentageAction = 5;
        criticalPowerAction = "HybridSleep";
      };

      # Enable TLP for power management
      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_MAX_PERF_ON_AC = 100;
          CPU_MAX_PERF_ON_BAT = 50;

          START_CHARGE_THRESH_BAT0 = 50;
          STOP_CHARGE_THRESH_BAT0 = 80;
        };
      };
    };
  };
}
