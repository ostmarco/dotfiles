{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.extra) mkEnableOption mkPackageOption;

  cfg = config.modules.programs.zed;
in {
  options.modules.programs.zed = {
    enable = mkEnableOption "Enables Zed editor";
    package = mkPackageOption pkgs.zed-editor "The Zed editor package to install";
  };

  config = mkIf cfg.enable {
    user.packages = let
      zed = pkgs.buildFHSUserEnv {
        name = "zed";
        targetPkgs = _: [cfg.package];

        runScript = "zed";
      };
    in [zed];
  };
}
