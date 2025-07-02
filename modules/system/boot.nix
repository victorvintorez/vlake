{ config, lib, ... }:
let
  cfg = config.vlake.system.boot;

  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) int;
in {
  options.vlake.system.boot = {
    enable = mkEnableOption "Enable Bootloader";
    timeout = mkOption {
      type = int;
      description = "Bootloader Timeout";
      default = 1;
    };
    withPlymouth = mkEnableOption "Add Plymouth Loader";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        timeout = cfg.timeout;
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
          editor = false;
          memtest86.enable = true;
        };
        efi.canTouchEfiVariables = true;
      };
      plymouth = mkIf cfg.withPlymouth {
        enable = true;
        theme = "spinfinity";
      };
    };
  };
}
