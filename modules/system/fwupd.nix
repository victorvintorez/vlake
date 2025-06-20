{ config, lib, ... }:
let
  cfg = config.vlake.system.fwupd;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.system.fwupd = {
    enable = mkEnableOption "Enable Firmware Update Service";
  };

  config = mkIf cfg.enable { services.fwupd = { enable = true; }; };
}
