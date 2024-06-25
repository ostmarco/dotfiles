{lib, ...}: let
  inherit (lib) mkOption types;
in rec {
  mkAttrsOption = description:
    mkOption {
      inherit description;
      default = {};
      type = types.attrs;
    };

  mkBoolOption = default: description:
    mkOption {
      inherit description default;
      type = types.bool;
    };

  mkEnableOption = mkBoolOption false;

  mkPackageOption = default: description:
    mkOption {
      inherit default description;
      type =
        if default == null
        then types.nullOr types.package
        else types.package;
    };

  mkPackagesOption = description:
    mkOption {
      inherit description;
      default = [];
      type = types.listOf types.package;
    };

  mkStringOption = description:
    mkOption {
      inherit description;
      type = types.str;
    };

  mkStringsOption = description:
    mkOption {
      inherit description;
      default = [];
      type = types.listOf types.str;
    };

  mkPathOption = description:
    mkOption {
      inherit description;
      type = types.path;
    };
}
