{ config, lib, ... }:
let
  cfg = config.vlake.system;

  inherit (lib.options) mkOption;
  inherit (lib.types) str;
  inherit (lib) mkForce;
in {
  options.vlake.system = {
    hostname = mkOption {
      description = "hostname for the system";
      type = str;
    };

    username = mkOption {
      description = "username for the system";
      type = str;
    };

    platform = mkOption {
      description = "system architecture";
      type = str;
    };
  };

  config = {
    networking.hostName = cfg.hostname;

    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    nixpkgs.hostPlatform = cfg.platform;

    # Force enable required modules
    vlake.system.agenix.enable = mkForce true;
    vlake.system.boot.enable = mkForce true;
    vlake.system.dbus.enable = mkForce true;
    vlake.system.docs.enable = mkForce true;
    vlake.system.fwupd.enable = mkForce true;
    vlake.system.locale.enable = mkForce true;
    vlake.system.networking.enable = mkForce true;
    vlake.system.nix.enable = mkForce true;
    vlake.system.oomd.enable = mkForce true;
    vlake.system.pipewire.enable = mkForce true;
    vlake.system.secretservice.enable = mkForce true;
    vlake.system.security.enable = mkForce true;
    vlake.system.ssh.enable = mkForce true;
  };
}
