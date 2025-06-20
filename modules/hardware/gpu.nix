{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.hardware.gpu;

  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.types) enum;
in {
  options.vlake.hardware.gpu = {
    type = mkOption {
      type = enum [ "nvidia" "intel" ];
      description = "gpu manufacturer";
    };
  };

  config = mkMerge [
    mkIf
    (cfg.type == "intel")
    {
      boot.initrd.kernelModules = [ "i915" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
          libdrm
          libva
          libva-vdpau-driver
          libvdpau-va-gl
          intel-vaapi-driver
          intel-media-driver
        ];
        extraPackages32 = with pkgs.driversi686Linux; [
          mesa
          libvdpau-va-gl
          intel-vaapi-driver
          intel-media-driver
        ];
      };
    }

    mkIf
    (cfg.type == "nvidia")
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.latest;
          open = true;
          videoAcceleration = true;
          nvidiaSettings = true;
          modesetting.enable = true;
          powerManagement.enable = true;
          gsp.enable = true;
        };
      };
    }
  ];
}
