{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.system.security;

  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) submodule enum;
in {
  options.vlake.system.security = {
    enable = mkEnableOption "Enable Security";
    enableFingerprint = mkEnableOption "Enable Fingerprint Support";
    yubikey = mkOption {
      description = "yubikey support";
      type = submodule {
        options = {
          enable = mkEnableOption "Enable Yubikey Support";
          pamType = mkOption {
            description = "Yubikey Auth Implementation";
            type = enum [ "2ndFactor" "passwordless" ];
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    security = {
      pam = {
        rssh = { enable = true; };
        u2f = mkIf cfg.yubikey.enable {
          enable = true;
          control = if cfg.yubikey.type == "2ndFactor" then
            "required"
          else if cfg.yubikey.type == "passwordless" then
            "sufficient"
          else
            "optional";
          settings = { cue = true; };
        };
        services = {
          login.fprintAuth = cfg.enableFingerprint;
          sudo.fprintAuth = cfg.enableFingerprint;
          login.u2fAuth = cfg.yubikey.enable;
          sudo.u2fAuth = cfg.yubikey.enable;
        };
      };
      polkit = { enable = true; };
    };
    services.udev.extraRules = mkIf cfg.yubikey.enable ''
      	ACTION=="remove",\
       	ENV{ID_BUS}=="usb",\
        ENV{ID_MODEL_ID}=="0407",\
        ENV{ID_VENDOR_ID}=="1050",\
        ENV{ID_VENDOR}=="Yubico",\
        RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
    '';

    systemd.services.fprintd = mkIf cfg.enableFingerprint {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };
    services.fprintd.enable = cfg.enableFingerprint;

    programs.yubikey-touch-detector = mkIf cfg.yubikey.enable {
      enable = true;
      libnotify = false;
      unixSocket = false;
    };
    environment.systemPackages =
      mkIf cfg.yubikey.enable (with pkgs; [ yubikey-manager ]);
  };
}
