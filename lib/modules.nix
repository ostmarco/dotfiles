{lib, ...}: let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit
    (lib)
    filterAttrs
    hasPrefix
    hasSuffix
    id
    mapAttrs'
    mapAttrsToList
    nameValuePair
    removeSuffix
    ;
in rec {
  mapFilterAttrs = pred: fn: attrs: filterAttrs pred (mapAttrs' fn attrs);

  mapModules = dir: fn:
    mapFilterAttrs
    (name: value: value != null && !(hasPrefix "_" name))
    (name: value: let
      path = "${dir}/${name}";
    in
      if value == "directory" && pathExists "${path}/default.nix"
      then nameValuePair name (fn path)
      else if value == "regular" && name != "default.nix" && hasSuffix ".nix" name
      then nameValuePair (removeSuffix ".nix" name) (fn path)
      else nameValuePair "" null)
    (readDir dir);

  mapModules' = dir: fn: attrValues (mapModules dir fn);

  mapModulesRec = dir: fn:
    mapFilterAttrs
    (name: value: value != null && !(hasPrefix "_" name))
    (name: value: let
      path = "${dir}/${name}";
    in
      if value == "directory" && pathExists "${path}/default.nix"
      then nameValuePair name (mapModulesRec path fn)
      else if value == "regular" && name != "default.nix" && hasSuffix ".nix" name
      then nameValuePair (removeSuffix ".nix" name) (fn path)
      else nameValuePair "" null)
    (readDir dir);

  mapModulesRec' = dir: fn: let
    dirs =
      mapAttrsToList
      (name: value: "${dir}/${name}")
      (filterAttrs (name: value: value == "directory" && !(hasPrefix "_" name)) (readDir dir));

    files = attrValues (mapModules dir id);
    paths = files ++ concatLists (map (dir: mapModulesRec' dir id) dirs);
  in
    map fn paths;
}
