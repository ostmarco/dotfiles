{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) types mkAliasDefinitions mkOption;
  inherit (lib.extra) mkAttrsOption mkPackageOption mkPackagesOption mkStringOption mkStringsOption;

  cfg = config.user;
in {
  options.user = {
    name = mkStringOption "The name of the user account.";
    description = mkStringOption "A short description of the user account.";
    groups = mkStringsOption "The user's groups.";

    packages = mkPackagesOption "The set of packages that should be made available to the user.";

    sessionVariables = mkAttrsOption "Environment variables set on login.";

    shell = mkPackageOption pkgs.shadow "The user shell. Defaults to bash.";

    shellAliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Shell aliases.";
    };

    home = {
      programs = mkAttrsOption "Programs to configure with home-manager.";
      services = mkAttrsOption "Services to configure with home-manager.";

      extraConfig = mkAttrsOption "Extra configuration for home-manager.";
    };
  };

  config = {
    users.users.${cfg.name} = {
      inherit (cfg) description packages shell;

      isNormalUser = true;
      extraGroups = cfg.groups;
    };

    i18n.defaultLocale = "en_US.UTF-8";

    environment.shells = [cfg.shell];

    programs.dconf.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${cfg.name} = let
        extraConfig = builtins.removeAttrs cfg.home.extraConfig ["programs" "services"];
      in
        extraConfig
        // {
          home.sessionVariables = cfg.sessionVariables;

          programs = mkAliasDefinitions options.user.home.programs;
          services = mkAliasDefinitions options.user.home.services;

          home.stateVersion = "23.11";
        };
    };

    nix.settings.trusted-users = ["root" cfg.name];
    nix.settings.allowed-users = ["root" cfg.name];
  };
}
