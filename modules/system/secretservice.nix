{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.system.secretservice;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.system.secretservice = {
    enable = mkEnableOption "Enable Secret Service (Gnome Keyring)";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring = { enable = true; };

    environment.systemPackages = with pkgs; [ libsecret gcr_4 ];

    programs.seahorse.enable = config.vlake.gui.enable;
  };
}
