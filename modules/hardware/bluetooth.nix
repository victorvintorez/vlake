{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.hardware.bluetooth;

  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) bool;
in {
  options.vlake.hardware.bluetooth = {
    enable = mkEnableOption "Enable Bluetooth";
    onByDefault = mkOption {
      type = bool;
      description = "Should Bluetooth be On by default";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.onByDefault;
    };

    services.blueman.enable = config.vlake.gui.enable;

    environment.systemPackages = with pkgs; [ bluetuith ];
  };
}
