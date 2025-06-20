{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.system.nix;

  inherit (config.vlake.system) username;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.system.nix = {
    enable = mkEnableOption "Enable Nix Optimizations (Required)";
  };

  config = mkIf cfg.enable {
    nix = {
      channel.enable = false;

      gc = {
        automatic = true;
        dates = "weekly";
        persistent = true;
      };

      optimise = {
        automatic = true;
        dates = "weekly";
        persistent = true;
      };

      settings = {
        experimental-features =
          [ "flakes" "nix-command" "pipe-operators" "no-url-literals" ];
        trusted-users = [ "root" config.vlake.system.username ];
        auto-optimise-store = true;
        keep-outputs = true;
        keep-derivations = true;
        use-xdg-base-directories = true;
        warn-dirty = false;

        # Binary Caches
        substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    nixpkgs.config = {
      allowAliases = false;
      allowUnfree = true;
      cudaSupport = true;
    };

    system.switch = {
      enable = true;
      enableNg = true;
    };

    # Nix Tools
    users.users.${username}.packages = with pkgs; [ nix-index ];
  };
}
