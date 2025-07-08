{ config, lib, ... }:
let
  cfg = config.vlake.hardware.mouse;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.hardware.mouse = {
    enable = mkEnableOption "Enable Logitech Mouse Support";
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = config.vlake.gui.enable;
    };
  };
}
