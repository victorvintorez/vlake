let
  yubikey-supernova =
    "age1yubikey1qg6hpwtf2flclwmuj2djjvqz83pcnjctftqzauc09utfzawsr3jeu3wr2jn";
  yubikey-wormhole =
    "age1yubikey1qv9mv7adpyfs0lft9t48c2u64x73fzmmg7u0fxgup2h2vzcj9lgz5cja5tv";

  supernova_user_old =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIj3VOLQFFJc47PG5O3DYJ8J5qQCcEjoWAXmnugnvEL6";
  supernova_host_old =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDw+mXhc63/rnjVOcRdOh7m7k6nDW1pFUBB1ytraV6Sg";

  wormhole_user_old =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgFnUbcVvQH531tcPQpKWkNIaa/K1nWvnjHstZiEj8y";
  wormhole_host_old =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7/jZZ+TGgJenZOpydKAL20MyjXeGfMNh+QJ62ag0TK";

  supernova_old = [ supernova_user_old supernova_host_old ];
  wormhole_old = [ wormhole_user_old wormhole_host_old ];

  keys = [ yubikey-supernova yubikey-wormhole ];
in { "defaultPassword.age".publicKeys = keys ++ supernova_old ++ wormhole_old; }
