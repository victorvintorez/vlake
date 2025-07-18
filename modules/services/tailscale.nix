{ config, lib, ... }:
let
  cfg = config.vlake.services.tailscale;
  inherit (lib.options) mkEnableOption;
  inherit (lib.meta) mkIf;
in {
  options.vlake.services.tailscale = {
    enable = mkEnableOption "Enable Tailscale";
  };

  config = mkIf cfg.enable {
    # Something
    # Something
  };
}
