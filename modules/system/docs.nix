{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.system.docs;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.system.docs = {
    enable = mkEnableOption "Enable Documentation";
  };

  config = mkIf cfg.enable {
    documentation = {
      enable = true;
      dev.enable = false;
      doc.enable = false;
      info.enable = false;
      man = {
        enable = true;
        generateCaches = false;
        man-db.enable = false;
        mandoc.enable = true;
      };
      nixos = {
        enable = true;
        includeAllModules = true;
        splitBuild = true;
      };
    };

    # Posix shell development docs
    environment.systemPackages = with pkgs; [ man-pages-posix ];
  };
}
