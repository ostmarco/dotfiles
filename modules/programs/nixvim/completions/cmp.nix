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
        cmp = {
          enable = true;
          autoEnableSources = true;

          settings = {
            experimental.ghost_text = true;

            mapping = {
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping.select_next_item()";
              "<C-k>" = "cmp.mapping.select_prev_item()";
              "<C-e>" = "cmp.mapping.abort()";
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            };

            sources = let
              mkSources = names: builtins.map (name: {inherit name;}) names;
            in
              (mkSources ["nvim_lsp" "emoji" "crates"])
              ++ [
                {
                  name = "buffer";
                  option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                  keywordLength = 3;
                }

                {
                  name = "path";
                  keywordLength = 3;
                }

                {
                  name = "luasnip";
                  keywordLength = 3;
                }
              ];

            performance = {
              fetching_timeout = 500;
              max_view_entries = 30;
            };

            snippet.expand = ''
              function(args)
                require("luasnip").lsp_expand(args.body)
              end
            '';

            window.completion.border = "solid";
            window.documentation.border = "solid";
          };
        };

        cmp-emoji.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-buffer.enable = true;
        cmp-path.enable = true;
        cmp_luasnip.enable = true;
      };

      extraConfigLua = ''
        local cmp = require("cmp")

        cmp.setup.cmdline({ "/", "?" }, {
          sources = {
            { name = "buffer" }
          }
        })
      '';
    };
  };
}
