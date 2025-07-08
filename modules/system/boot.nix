{ config, lib, ... }:
let
  cfg = config.vlake.system.boot;

  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) int submodule string listOf package;
in {
  options.vlake.system.boot = {
    enable = mkEnableOption "Enable Bootloader";
    timeout = mkOption {
      type = int;
      description = "Bootloader Timeout";
      default = 1;
    };
    plymouth = mkOption {
      description = "Plymouth Loader Options";
      type = submodule {
        options = {
          enable = mkEnableOption "Add Plymouth Loader";
          theme = mkOption {
            description = "The name of the Theme to use";
            type = string;
            default = "spinfinity";
          };
          themePackage = mkOption {
            description = "A custom theme package to use";
            type = listOf package;
            default = [ ];
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    boot = {
      loader = {
        timeout = cfg.timeout;
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
          editor = false;
          memtest86.enable = true;
        };
        efi.canTouchEfiVariables = true;
        generationsDir.copyKernels = true;
      };
      plymouth = mkIf cfg.plymouth.enable {
        enable = true;
        theme = cfg.plymouth.theme;
        themePackages = cfg.plymouth.themePackage;
      };

      swraid.enable = false;
    };
  };
}
