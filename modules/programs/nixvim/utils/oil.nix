{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.programs.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.oil = {
        enable = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "-";
          action = ":Oil<CR>";
          options = {
            desc = "Open parent directory";
            silent = true;
          };
        }
      ];
    };
  };
}
