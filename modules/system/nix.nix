{ config, lib, pkgs, ... }:
let
  cfg = config.vlake.system.nix;

  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
in {
  options.vlake.system.nix = {
    enable = mkEnableOption "Enable Nix Optimizations (Required)";
  };

  config = mkIf cfg.enable {
    nix = {
      channel.enable = false;

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
        substituters = [
          "https://cache.nixos.org"
          "https://nixpkgs-unfree.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    nixpkgs.config = {
      allowAliases = false;
      allowUnfree = true;
      cudaSupport = true;
    };

    # Nix Tools
    programs.nh = {
      enable = true;
      flake = config.vlake.system.flake;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep 5";
      };
    };

    environment.systemPackages = with pkgs; [ nix-index ];
  };
}
