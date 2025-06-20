{ config, lib, ... }:
let
  cfg = config.vlake.hardware.cpu;

  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.types) enum;
in {
  options.vlake.hardware.cpu = {
    type = mkOption {
      type = enum [ "amd" "intel" ];
      description = "cpu manufacturer";
    };
  };

  config = mkMerge [
    mkIf
    (cfg.type == "amd")
    {
      hardware.cpu.amd.updateMicrocode = true;

      kernelParams = [ "amd_pstate=active" ];

      blacklistedKernelModules = [ "k10temp" ];
      extraModulePackages = [ config.boot.kernelPackages.zenpower ];
      kernelModules = [ "zenpower" ];
    }

    mkIf
    (cfg.type == "intel")
    {
      hardware.cpu.intel.updateMicrocode = true;

      # thermald or throttled?
    }
  ];
}
