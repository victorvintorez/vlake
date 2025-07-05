{ config, lib, ... }:
let
  cfg = config.vlake.hardware.thunderbolt;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.hardware.thunderbolt = {
    enable = mkEnableOption "Enable Thunderbolt Support";
  };

  config = mkIf cfg.enable { hardware.bolt.enable = true; };
}
