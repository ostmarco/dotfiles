{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (lib.extra) mkBoolOption mkEnableOption;

  cfg = config.modules.services.docker;
in {
  options.modules.services.docker = {
    enable = mkEnableOption "Enables Docker";
    enableOnBoot = mkEnableOption "Enables Docker on boot";

    rootless = mkBoolOption false "Run Docker without root";
    compose = mkBoolOption false "Enables Docker Compose";
  };

  config = mkMerge [
    {
      virtualisation.docker = {
        inherit (cfg) enable enableOnBoot;

        autoPrune.enable = true;
      };
    }
    (mkIf cfg.rootless {
      virtualisation.docker.rootless = {
        enable = cfg.rootless;
        setSocketVariable = cfg.rootless;
      };
    })
    (mkIf (cfg.enable && cfg.compose) {
      environment.systemPackages = [
        pkgs.docker-compose
      ];
    })
  ];
}
