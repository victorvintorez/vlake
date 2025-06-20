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
          type = mkOption {
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
          login.u2fAuth = true;
          sudo.u2fAuth = true;
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
  };
}
