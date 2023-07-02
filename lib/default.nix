{
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) makeExtensible attrValues foldr;

  mylib = makeExtensible (
    self:
      import ./options.nix {inherit self inputs lib pkgs;}
  );
in
  mylib.extend (self: super: foldr (a: b: a // b) {} (attrValues super))
