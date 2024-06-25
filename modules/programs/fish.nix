{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.extra) mkEnableOption;

  cfg = config.modules.programs.fish;
  kitty = config.modules.programs.kitty;
  starship = config.modules.programs.starship;
  user = config.user;
in {
  options.modules.programs.fish = {
    enable = mkEnableOption "Enables Fish shell";
  };

  config = {
    programs.fish.enable = cfg.enable;
    user.shell = mkIf cfg.enable pkgs.fish;
    user.packages = mkIf cfg.enable [
      pkgs.fishPlugins.tide
    ];

    user.home.programs.fish = {
      inherit (cfg) enable;

      # TODO: move starship command
      interactiveShellInit = ''
        set -g fish_cursor_default block;
        set -g fish_cursor_insert line;
        set -g fish_cursor_replace_one underscore
        set -g fish_greeting

        ${
          if kitty.enable
          then "set -g TERM xterm"
          else ""
        }

        ${
          if starship.enable
          then "starship init fish | source"
          else ""
        }
      '';

      shellAliases = user.shellAliases;
    };
  };
}
