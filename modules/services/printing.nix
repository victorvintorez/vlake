{ config, lib, ... }:
let
  cfg = config.vlake.services.printing;
  inherit (lib.options) mkEnableOption;
  inherit (lib.meta) mkIf;
in {
  options.vlake.services.printing = {
    enable = mkEnableOption "Enable Printing";
  };

  config = mkIf cfg.enable {
    # Something
    # Something
  };
}
