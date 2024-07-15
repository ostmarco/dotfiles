{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkForce mkIf;
  inherit (lib.extra) mkEnableOption mkPathOption;

  cfg = config.modules.services.stylix;
in {
  options.modules.services.stylix = {
    enable = mkEnableOption "Enables Stylix";
    wallpaper = mkPathOption "Wallpaper for Stylix to set";
  };

  config = mkIf cfg.enable {
    stylix = {
      inherit (cfg) enable;

      image = mkForce cfg.wallpaper;
      polarity = "dark";

      cursor.size = 24;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      fonts = let
        ny = {
          name = "New York";
          package = pkgs.ny;
        };

        iosevka = {
          name = "Iosevka Comfy Motion";
          package = pkgs.iosevka-comfy.comfy-motion;
        };
      in {
        sizes = {
          applications = 11;
          desktop = 11;
          popups = 11;
          terminal = 11;
        };

        serif = ny;
        sansSerif = iosevka;
        monospace = iosevka;
      };

      opacity = {
        terminal = 0.8;
      };

      targets = {
        chromium.enable = false;
      };
    };

    user.home.extraConfig = {
      gtk = {
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.catppuccin-papirus-folders;
        };
      };
    };
  };
}
