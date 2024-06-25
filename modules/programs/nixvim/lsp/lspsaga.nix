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
      plugins.lspsaga = {
        enable = true;

        ui.border = "rounded";
        hover.openCmd = "!google-chrome-stable";

        codeAction = {
          showServerName = true;
          keys = {
            exec = "<CR>";
            quit = ["<Esc>" "q"];
          };
        };

        lightbulb.enable = false;
        implement.enable = false;

        rename.keys = {
          exec = "<CR>";
          quit = ["<C-k>" "<Esc>"];
          select = "x";
        };

        outline = {
          closeAfterJump = true;
          keys = {
            jump = "e";
            quit = "q";
            toggleOrJump = "e";
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = "gd";
          action = "<cmd>Lspsaga finder def<CR>";
          options = {
            desc = "Goto Definition";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "gr";
          action = "<cmd>Lspsaga finder ref<CR>";
          options = {
            desc = "Goto References";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "gI";
          action = "<cmd>Lspsaga finder imp<CR>";
          options = {
            desc = "Goto Implementation";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "gT";
          action = "<cmd>Lspsaga peek_type_definition<CR>";
          options = {
            desc = "Type Definition";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "K";
          action = "<cmd>Lspsaga hover_doc<CR>";
          options = {
            desc = "Hover";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "<leader>cw";
          action = "<cmd>Lspsaga outline<CR>";
          options = {
            desc = "Outline";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "<leader>cr";
          action = "<cmd>Lspsaga rename<CR>";
          options = {
            desc = "Rename";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "<leader>ca";
          action = "<cmd>Lspsaga code_action<CR>";
          options = {
            desc = "Code Action";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "<leader>cd";
          action = "<cmd>Lspsaga show_line_diagnostics<CR>";
          options = {
            desc = "Line Diagnostics";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "[d";
          action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
          options = {
            desc = "Next Diagnostic";
            silent = true;
          };
        }

        {
          mode = "n";
          key = "]d";
          action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
          options = {
            desc = "Previous Diagnostic";
            silent = true;
          };
        }
      ];
    };
  };
}
