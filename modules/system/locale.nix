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
    chrony.enable = false;
    timesyncd = {
      enable = true;
      servers = [
        "0.europe.pool.ntp.org"
        "1.europe.pool.ntp.org"
        "2.europe.pool.ntp.org"
        "3.europe.pool.ntp.org"
      ];
      extraConfig = ''
        PollIntervalMinSec=128
      '';
    };
    time.timeZone = cfg.timezone;

    i18n = rec {
      defaultLocale = "en_US.UTF-8";
      extraLocales = [ "en_GB.UTF-8/UTF-8" "nb_NO.UTF-8/UTF-8" ];
      extraLocaleSettings = {
        LANG = defaultLocale;
        LC_COLLATE = defaultLocale;
        LC_CTYPE = defaultLocale;
        LC_MESSAGES = defaultLocale;
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "nb_NO.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };
    };
  };
}
