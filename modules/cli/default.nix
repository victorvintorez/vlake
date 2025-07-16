{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.cli;

  inherit (config.vlake.system) username;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum;
  inherit (lib.meta) mkIf mkMerge mkForce;
in {
  imports = [ ];

  options.vlake.cli = {
    enable = mkEnableOption "Enable CLI Defaults";
    shell = mkOption {
      description = "Shell for the user";
      type = enum [ "fish" ];
      default = "fish";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    mkIf
    (cfg.shell == "fish")
    {
      users.users.${username}.shell = pkgs.fish;

      config.vlake.cli.fish.enable = mkForce true;
    }
    {
      # Some default cli programs that should be installed
      environment.systemPackages = with pkgs; [ curl inxi wget ];

      config.vlake.cli.git.enable = mkForce true;
    }
  ]);
}
