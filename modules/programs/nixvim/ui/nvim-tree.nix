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
      plugins.nvim-tree = {
        enable = true;

        hijackCursor = true;
        sortBy = "case_sensitive";

        view = {
          side = "right";
        };

        renderer = {
          addTrailing = true;
          groupEmpty = true;

          icons = {
            gitPlacement = "signcolumn";
            modifiedPlacement = "signcolumn";
          };
        };
      };

      keymaps = [
        {
          mode = ["n"];
          key = "<leader>t";
          action = "<cmd>NvimTreeOpen<cr>";
          options = {
            desc = "Open file tree";
          };
        }
      ];
    };
  };
}
