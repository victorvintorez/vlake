{ inputs, lib, ... }:
let
  inherit (inputs) self;

  inherit (lib.attrsets) listToAttrs;
  inherit (lib.path) append;

  getSystemConfig = hostDir:
    (import (append hostDir "system.nix")) { inherit inputs; };

  createHost = extraModules: hostDir:
    lib.nixosSystem {
      system = null;
      specialArgs = { inherit lib inputs self; };
      modules = [ hostDir ../modules ] ++ extraModules;
    };

  createHosts = hosts:
    listToAttrs (map (host: {
      name = (getSystemConfig host).vlake.system.hostname;
      value = createHost [ ];
    }) hosts);
in createHosts [ ./supernova ./wormhole ]
