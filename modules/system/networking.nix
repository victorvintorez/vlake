{ config, lib, ... }:
let
  cfg = config.vlake.system.networking;

  inherit (config.vlake.system) username;
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkForce;
in {
  options.vlake.system.networking = {
    enable = mkEnableOption "Enable Networking (Required)";
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        wifi = {
          backend = "iwd";
          macAddress = "permanent";
          powersave = false;
        };
        ethernet.macAddress = "permanent";
      };
      firewall = {
        enable = true;
        checkReversePath = "loose";
      };
    };
    services.resolved = { enable = true; };
    systemd = {
      targets.network-online.wantedBy = mkForce [ ];
      services.NetworkManager-wait-online.wantedBy = mkForce [ ];
    };
    users.users.${username} = { extraGroups = [ "networkManager" ]; };
  };
}
