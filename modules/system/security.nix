{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.system.security;

  inherit (lib) concatStrings;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf mkMerge;
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
          settings = {
            interactive = false;
            cue = true;
            origin = "pam://yubico";
            authfile = pkgs.writeText "u2f-keys" (concatStrings [
              config.vlake.system.username
              ":<key-handle>,<user-key>,<cose-type>,<options>"
              ":<key-handle>,<user-key>,<cose-type>,<options>"
            ]);
          };
        };
        services = {
          login.fprintAuth = cfg.enableFingerprint;
          login.u2fAuth = cfg.yubikey.enable;
          sudo.fprintAuth = cfg.enableFingerprint;
          sudo.u2fAuth = cfg.yubikey.enable;
          polkit.fprintAuth = cfg.enableFingerprint;
          polkit.u2fAuth = cfg.yubikey.enable;
        };
      };
      polkit.enable = true;
      rtkit.enable = true;
    };

    services = {
      pcscd.enable = cfg.yubikey.enable;
      fprintd.enable = cfg.enableFingerprint;
      udev.extraRules = mkIf cfg.yubikey.enable ''
        	ACTION=="remove",\
         	ENV{ID_BUS}=="usb",\
          ENV{ID_MODEL_ID}=="0407",\
          ENV{ID_VENDOR_ID}=="1050",\
          ENV{ID_VENDOR}=="Yubico",\
          RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      '';
    };

    systemd.services.fprintd = mkIf cfg.enableFingerprint {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
    };
    programs.yubikey-touch-detector = mkIf cfg.yubikey.enable {
      enable = true;
      libnotify = false;
      unixSocket = false;
    };
    environment.systemPackages = mkMerge [
      (mkIf config.vlake.gui.enable (with pkgs; [ cmd-polkit ]))
      (mkIf cfg.yubikey.enable (with pkgs; [ yubikey-manager ]))
      (mkIf (cfg.yubikey.enable && config.vlake.gui.enable)
        (with pkgs; [ yubioath-flutter ]))
    ];
  };
}
