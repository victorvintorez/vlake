{ config, lib, ... }:
let
  cfg = config.vlake.system.oomd;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.system.oomd = {
    enable = mkEnableOption "Enable Out-Of-Memory Watcher";
  };

  config = mkIf cfg.enable {
    systemd.oomd = {
      enable = true;
      enableRootSlice = true;
      enableSystemSlice = true;
      enableUserSlices = true;
    };
  };
}
