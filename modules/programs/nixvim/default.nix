{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.extra) mkEnableOption mkPackageOption mkBoolOption;

  cfg = config.modules.programs.nixvim;
in {
  options.modules.programs.nixvim = {
    enable = mkEnableOption "Enables nixvim";
    package = mkPackageOption pkgs.neovim-unwrapped "The neovim package to install";

    viAlias = mkBoolOption false "Symlink vi to nvim binary";
    vimAlias = mkBoolOption false "Symlink vim to nvim binary";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      inherit (cfg) enable package viAlias vimAlias;

      clipboard.providers.wl-copy.enable = true;

      plugins = {
        comment.enable = true;
        crates-nvim.enable = true;
        gitsigns.enable = true;
        lualine.enable = true;
        luasnip.enable = true;
        markdown-preview.enable = true;
        nvim-autopairs.enable = true;
        schemastore.enable = true;
        toggleterm.enable = true;
        transparent.enable = true;
        treesitter-context.enable = true;
        treesitter.enable = true;
        trouble.enable = true;
        which-key.enable = true;
      };

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          styles = {
            booleans = [
              "bold"
              "italic"
            ];
            conditionals = [
              "bold"
            ];
          };
        };
      };
    };
  };
}
