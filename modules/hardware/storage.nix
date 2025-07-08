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
    boot.supportedFilesystems = [ "btrfs" ];

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

      lvm.enable = false;

      journald.extraConfig = ''
        	SystemMaxUse=100M
         	RuntimeMaxUse=50M
          SystemMaxFileSize=50M
      '';
    };

    fileSystems."/boot".options = [ "nodev" "nosuid" "noexec" ];
  };
}
