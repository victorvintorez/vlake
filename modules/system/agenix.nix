{ config, lib, inputs, pkgs, ... }:
let
  cfg = config.vlake.system.agenix;

  inherit (config.vlake.system) username;
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  imports = [ inputs.agenix.nixosModules.default ];

  options.vlake.system.agenix = { enable = mkEnableOption "Enable Agenix"; };

  config = mkIf cfg.enable {
    users.users.${username}.packages =
      [ inputs.agenix.packages.${pkgs.stdenv.system}.default ];
  };
}
