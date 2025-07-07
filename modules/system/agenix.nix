{ config, lib, inputs, pkgs, ... }:
let
  cfg = config.vlake.system.agenix;

  inherit (config.vlake.system) flake;
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;
  inherit (lib.meta) makeBinPath filter;
in {
  imports = [ inputs.agenix.nixosModules.default ];

  options.vlake.system.agenix = { enable = mkEnableOption "Enable Agenix"; };

  config = mkIf cfg.enable {
    age = {
      ageBin = "PATH=$PATH:${
          makeBinPath [ pkgs.age-plugin-yubikey ]
        } ${pkgs.age}/bin/age";
      identityPaths = [
        "${flake}/secrets/identities/yubikey-supernova.txt"
        "${flake}/secrets/identities/yubikey-wormhole.txt"
        "../../secrets/identities/yubikey-supernova.txt" # Just in case flake is not in flake location (such as during install)
        "../../secrets/identities/yubikey-wormhole.txt" # Just in case flake is not in flake location (such as during install)
      ] ++ map (e: e.path)
        (filter (e: e.type == "ed25519") config.services.openssh.hostKeys);
      secrets = { defaultPassword.file = ../../secrets/defaultPassword.age; };
    };

    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.stdenv.system}.default
      pkgs.age-plugin-yubikey
    ];
  };
}
