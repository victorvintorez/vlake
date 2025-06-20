{ nixpkgs, ... }:
nixpkgs.lib.extend (_final: prev:
  let inherit (prev) mkIf;
  in { vlake = { modules = { mkIfNotNull = x: mkIf (x != null); }; }; })
