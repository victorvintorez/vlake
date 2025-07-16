{ config, lib, ... }:
let
  cfg = config.vlake.cli.git;
  inherit (lib.options) mkEnableOption;
  inherit (lib.meta) mkIf;
in {
  options.vlake.cli.git = { enable = mkEnableOption "Enable Git"; };

  config = mkIf cfg.enable {
    # Something
    # Something
  };
}
