{ inputs, ... }: {
  import = [ inputs.disko.nixosModules.disko ];

  disko.devices = { };
}
