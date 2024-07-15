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
      plugins = {
        lsp-format.enable = true;
        lsp = {
          enable = true;

          servers = {
            clangd.enable = true;
            cmake.enable = true;

            jsonls.enable = true;
            marksman.enable = true;

            omnisharp = {
              enable = true;
              settings = {
                enableImportCompletion = true;
                organizeImportsOnFormat = true;
              };
            };

            nil-ls.enable = true;

            rust-analyzer = {
              enable = true;

              installCargo = false;
              installRustc = false;
            };

            yamlls.enable = true;
            zls.enable = true;
          };

          keymaps = {
            silent = true;

            lspBuf = {
              gd = {
                action = "definition";
                desc = "Goto Definition";
              };
              gr = {
                action = "references";
                desc = "Goto References";
              };
              gD = {
                action = "declaration";
                desc = "Goto Declaration";
              };
              gI = {
                action = "implementation";
                desc = "Goto Implementation";
              };
              gT = {
                action = "type_definition";
                desc = "Type Definition";
              };
              K = {
                action = "hover";
                desc = "Hover";
              };
              "<leader>cw" = {
                action = "workspace_symbol";
                desc = "Workspace Symbol";
              };
              "<leader>cr" = {
                action = "rename";
                desc = "Rename";
              };
            };

            diagnostic = {
              "<leader>cd" = {
                action = "open_float";
                desc = "Line Diagnostics";
              };
              "[d" = {
                action = "goto_next";
                desc = "Next Diagnostic";
              };
              "]d" = {
                action = "goto_prev";
                desc = "Previous Diagnostic";
              };
            };
          };
        };
      };
      extraConfigLua = ''
        local _border = "rounded"

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
          vim.lsp.handlers.hover, {
            border = _border
          }
        )

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help, {
            border = _border
          }
        )

        vim.diagnostic.config{
          float={border=_border}
        };

        require('lspconfig.ui.windows').default_options = {
          border = _border
        }
      '';
    };
  };
}
