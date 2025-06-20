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
      modules = [ hostDir ../modules ./common/core ] ++ extraModules;
    };

  desktop = createHost [ ./common/desktop ];

  createHosts = hosts:
    listToAttrs (map (host: {
      name = (getSystemConfig host.dir).vlake.system.hostname;
      value = host.type host.dir;
    }) hosts);
in createHosts [
  {
    dir = ./supernova;
    type = desktop;
  }
  {
    dir = ./wormhole;
    type = desktop;
  }
]
