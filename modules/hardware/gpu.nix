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
      services.xserver.videoDrivers = [ "modesetting" ];
      boot.initrd.kernelModules = [ "i915" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
          libva-vdpau-driver
          libvdpau-va-gl
          intel-media-driver
        ];
        extraPackages32 = with pkgs.driversi686Linux; [
          mesa
          libva-vdpau-driver
          libvdpau-va-gl
          intel-media-driver
        ];
      };
      environment.systemPackages = with pkgs.nvtopPackages; [ intel ];
    }

    mkIf
    (cfg.type == "nvidia")
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        };
        nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.latest;
          open = true;
          videoAcceleration = true;
          nvidiaPersistenced = true;
          nvidiaSettings = false;
          modesetting.enable = true;
          powerManagement.enable = true;
          gsp.enable = true;
        };
      };
      environment.systemPackages = with pkgs.nvtopPackages; [ nvidia ];
    }
  ];
}
