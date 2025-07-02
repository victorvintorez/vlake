_: {
  imports = [ ./disko.nix ./hardware-configuration.nix ];

  vlake = {
    system = {
      hostname = "wormhole";
      username = "vvintorez";
      platform = "x86_64-linux";
    };
  };
}
