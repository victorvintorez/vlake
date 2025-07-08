{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.hardware.fan2go;

  inherit (lib.meta) getExe';
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) path;
in {
  options.vlake.hardware.fan2go = {
    enable = mkEnableOption "Enable fan2go Fan Control Support";
    config = mkOption {
      description = "The fan2go.yaml config to use";
      type = path;
    };
  };

  config = mkIf cfg.enable {
    # TODO: Update fan2go package, create and add fan2go-tui package
    environment.systemPackages = with pkgs; [ fan2go ];

    systemd.services.fan2go = {
      description = "Advanced Fan Control program";
      wantedBy = [ "multi-user.target" ];
      after = [ "lm-sensors.service" ];

      serviceConfig = {
        Restart = "always";
        ExecStart =
          "${getExe' pkgs.fan2go "fan2go"} -c ${cfg.config} --no-style";
      };
    };
  };
}
