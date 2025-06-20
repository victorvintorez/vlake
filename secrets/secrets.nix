let
  supernova_user =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIj3VOLQFFJc47PG5O3DYJ8J5qQCcEjoWAXmnugnvEL6";
  wormhole_user = "ssh-ed25519";

  supernova_host =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDw+mXhc63/rnjVOcRdOh7m7k6nDW1pFUBB1ytraV6Sg";
  wormhole_host = "ssh-ed25519";

  supernova = [ supernova_user supernova_host ];
  wormhole = [ wormhole_user wormhole_host ];
in { "".publicKeys = supernova ++ wormhole; }
