{ config, lib, ... }:
let
  cfg = config.vlake.system.locale;

  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;
  inherit (lib.types) string;
in {
  options.vlake.system.locale = {
    enable = mkEnableOption "Enable DBus";
    timezone = mkOption {
      description = "Timezone";
      type = string;
      default = "Europe/London";
    };
  };

  config = mkIf cfg.enable {
    time.timeZone = cfg.timezone;
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocales = [ "en_GB.UTF-8/UTF-8" "nb_NO.UTF-8/UTF-8" ];
    };
  };
}
