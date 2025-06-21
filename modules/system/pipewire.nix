{ config, lib, ... }:
let
  cfg = config.vlake.system.pipewire;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
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

    security.rtkit.enable = true;
  };
}
