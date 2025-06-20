{ config, lib, ... }:
let
  cfg = config.vlake.system.dbus;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.system.dbus = { enable = mkEnableOption "Enable DBus"; };

  config = mkIf cfg.enable { services.dbus = { implementation = "broker"; }; };
}
