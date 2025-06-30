{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.system.pipewire;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;
in {
  options.vlake.system.pipewire = {
    enable = mkEnableOption "Enable Pipewire";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    services.playerctld.enable = true;

    environment.systemPackages = mkMerge [
      (with pkgs; [ playerctl ])
      (mkIf config.vlake.gui.enable (with pkgs; [ pwvucontrol qpwgraph ]))
    ];
  };
}
