{ inputs, lib, ... }:
let
  inherit (inputs) self;

  inherit (lib.attrsets) listToAttrs;

  createHost = hostPlatform: hostDir:
    lib.nixosSystem {
      system = hostPlatform;
      specialArgs = { inherit lib inputs self; };
      modules = [ hostDir ../modules ];
    };

  createHosts = hosts:
    listToAttrs (map (hostDir:
      let hostConfig = (import hostDir { inherit inputs; }).vlake.system;
      in {
        name = hostConfig.hostname;
        value = createHost hostConfig.platform hostDir;
      }) hosts);
in createHosts [ ./supernova ./wormhole ]
