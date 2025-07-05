{ config, lib, inputs, ... }:
let
  cfg = config.vlake.system;

  inherit (lib.options) mkOption;
  inherit (lib.types) str enum;
  inherit (lib) mkForce;
in {
  imports = [
    ./agenix.nix
    ./boot.nix
    ./dbus.nix
    ./docs.nix
    ./fwupd.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./oomd.nix
    ./pipewire.nix
    ./secretservice.nix
    ./security.nix
    ./ssh.nix
    inputs.hjem.nixosModules.default
  ];

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
      type = enum [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    };

    flake = mkOption {
      description = "flake location";
      type = str;
      default = "/home/${cfg.username}/vlake";
    };
  };

  config = {
    networking.hostName = cfg.hostname;

    users.users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      passwordFile = config.age.secrets.defaultPassword.path;
    };

    hjem = {
      users.${cfg.username} = {
        enable = true;
        directory = "/home/${cfg.username}";
        user = cfg.username;
      };
      clobberByDefault = true;
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
