{ config, lib, ... }:
let
  cfg = config.vlake.system.boot;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.system.boot = {
    enable = mkEnableOption "Enable Bootloader";
    withPlymouth = mkEnableOption "Add Plymouth Bootloader";
    withWindows = mkEnableOption "Add Windows Boot Entry";
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        timeout = if cfg.withWindows then 5 else 0;
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
