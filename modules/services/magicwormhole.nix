{ config, lib, ... }:
let
  cfg = config.vlake.services.magicwormhole;
  inherit (lib.options) mkEnableOption;
  inherit (lib.meta) mkIf;
in {
  options.vlake.services.magicwormhole = {
    enable = mkEnableOption "Enable Magic Wormhole";
  };

  config = mkIf cfg.enable {
    # Something
    # Something
  };
}
