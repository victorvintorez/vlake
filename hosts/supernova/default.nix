_: {
  imports = [ ./disko.nix ];

  vlake = {
    system = {
      hostname = "supernova";
      username = "vvintorez";
      platform = "x86_64-linux";
    };
  };
}
