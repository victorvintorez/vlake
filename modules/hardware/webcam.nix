{ config, lib, ... }:
let
  cfg = config.vlake.hardware.webcam;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.hardware.webcam = {
    enable = mkEnableOption "Enable IPU6 Webcam Support";
  };

  config = mkIf cfg.enable {
    hardware.ipu6 = {
      enable = true;
      type = "ipu6ep";
    };
  };
}
