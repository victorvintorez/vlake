{ config, lib, ... }:
let
  cfg = config.vlake.hardware.monitors;

  inherit (lib.options) mkOption;
  inherit (lib.types) listOf float int bool str submodule;
  inherit (lib.types.ints) positive;
in {
  options.vlake.hardware.monitors = mkOption {
    type = listOf (submodule {
      options = {
        output = mkOption {
          description = "output name of monitor";
          type = str;
          example = "DP-1";
        };

        name = mkOption {
          description = "name of monitor";
          type = submodule {
            options = {
              make = mkOption {
                description = "make of monitor";
                type = str;
              };
              model = mkOption {
                description = "model of monitor";
                type = str;
              };
              serial = mkOption {
                description = "serial of the monitor";
                type = str;
              };
            };
          };
        };

        primary = mkOption {
          description = "is monitor primary";
          type = bool;
        };

        resolution = mkOption {
          description = "resolution of monitor";
          type = submodule {
            options = {
              w = mkOption {
                description = "width of monitor";
                type = positive;
              };
              h = mkOption {
                description = "height of monitor";
                type = positive;
              };
            };
          };
        };

        refreshRate = mkOption {
          description = "refresh rate of monitor";
          type = positive;
          default = 60;
        };

        vrr = mkOption {
          description = "enable vrr for monitor";
          type = bool;
          default = false;
        };

        position = mkOption {
          description = "position of monitor";
          type = submodule {
            options = {
              x = mkOption {
                description = "x position of monitor";
                type = int;
                default = 0;
              };
              y = mkOption {
                description = "y position of monitor";
                type = int;
                default = 0;
              };
            };
          };
        };

        rotate = mkOption {
          description = "rotation of monitor";
          type = int;
        };

        scale = mkOption {
          description = "scale of monitor";
          type = float;
        };

      };
    });
  };

  config = {
    assertions = [{
      assertion = ((lib.length cfg) != 0)
        -> ((lib.length (lib.filter (m: m.primary) cfg)) == 1);
      message = "Exactly one monitor must be set as primary";
    }];
  };
}
