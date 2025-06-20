{ config, lib, ... }:
let
  cfg = config.vlake.hardware.storage;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.hardware.storage = {
    enable = mkEnableOption "Enable Storage Optimizations";
  };

  config = mkIf cfg.enable {
    services = {
      btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
      };
      fstrim = {
        enable = true;
        interval = "weekly";
      };
      smartd = {
        enable = true;
        autodetect = true;
      };
    };

    fileSystems."/boot".options = [ "nodev" "nosuid" "noexec" ];
  };
}
