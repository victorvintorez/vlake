{
  description = "Victor Vintorez's Nix Flake";

  outputs = { nixpkgs, ... }@inputs:
    let
      lib = import ./lib { inherit nixpkgs; };

      nixosConfigurations = import ./hosts { inherit inputs lib; };

      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
    in {
      inherit nixosConfigurations;

      packages = forEachSystem (_:
        {
          # Something Here
        });
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
  };
}
