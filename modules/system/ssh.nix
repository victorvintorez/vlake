{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.system.ssh;

  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.types) bool;
in {
  options.vlake.system.ssh = {
    enable = mkEnableOption "Enable SSH Support";
    withSocketActivation = mkOption {
      description = "Enable Socket Activation";
      type = bool;
      default = true;
    };
    withFidoKeySupport = mkOption {
      description = "Enable FIDO/U2F Support";
      type = bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = cfg.withSocketActivation;
      settings = { PasswordAuthentication = false; };
    };
    programs.ssh = {
      startAgent = true;
      enableAskPassword = false;
    };

    environment.systemPackages = mkMerge [
      (mkIf cfg.withFidoKeySupport (with pkgs; [ libfido2 ]))
      (with pkgs; [ waypipe ])
    ];
  };
}
