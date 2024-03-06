{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) makeExtensible attrValues foldr;
  inherit (modules) mapModulesRec;

  modules = import ./modules.nix {inherit lib;};
  extra = makeExtensible (self: mapModulesRec ./. (file: import file {inherit self lib pkgs inputs;}));
in
  extra.extend (self: super: foldr (a: b: a // b) {} (attrValues super))
