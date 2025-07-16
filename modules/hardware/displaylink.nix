{ config, lib, ... }:
let
  cfg = config.vlake.hardware.displaylink;
  inherit (lib.options) mkEnableOption;
  inherit (lib.meta) mkIf;
in {
  options.vlake.hardware.displaylink = {
    enable = mkEnableOption "Enable Displaylink";
  };

  config = mkIf cfg.enable {
    # Something
    # Something
  };
}
