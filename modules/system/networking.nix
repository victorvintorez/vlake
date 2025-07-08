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
          macAddress = "random";
          powersave = false;
        };
        ethernet.macAddress = "permanent";
        unmanaged = [
          "interface-name:tailscale*"
          "interface-name:docker*"
          "type:bridge"
        ];
        extraConfig = ''
          connection.mdns=2
        '';
      };
      firewall = {
        enable = true;
        checkReversePath = "loose";
      };
      enableIPv6 = true;
      useDHCP = false;
      useNetworkd = true;
      nameservers = [
        # Cloudflare DNS
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
        # Quad9 DNS
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
    };
    services.resolved = {
      enable = true;
      dnsovertls = "true";
      fallbackDns = [
        # Cloudflare DNS
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111"
        "2606:4700:4700::1001"
        # Quad9 DNS
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
      domains = [ "~." ];
    };
    systemd = {
      targets.network-online.wantedBy = mkForce [ ];
      services.NetworkManager-wait-online.wantedBy = mkForce [ ];
    };
    users.users.${username} = { extraGroups = [ "networkManager" ]; };

    programs.nm-applet.enable = config.vlake.gui.enable;
  };
}
