{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.extra) mkEnableOption;

  fish = config.modules.programs.fish;
  cfg = config.modules.programs.kitty;
in {
  options.modules.programs.kitty = {
    enable = mkEnableOption "Enables Kitty terminal emulator.";
  };

  config = mkIf cfg.enable {
    user.home.programs.kitty = {
      enable = true;

      settings = {
        copy_on_select = true;
        disable_ligatures = "cursor";
        enable_audio_bell = false;
      };

      # TODO: use theming
      font = {
        name = "Zed Mono";
        size = 10.0;
      };

      theme = "Catppuccin-Macchiato";

      shellIntegration.enableFishIntegration = fish.enable;
    };
  };
}
