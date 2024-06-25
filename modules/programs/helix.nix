{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit
    (lib.extra)
    mkBoolOption
    mkEnableOption
    ;

  cfg = config.modules.programs.helix;
in {
  options.modules.programs.helix = {
    enable = mkEnableOption "Enables the Helix text editor.";
    defaultEditor = mkBoolOption false "Whether to configure hx as the default editor using the EDITOR environment variable";

    viAlias = mkBoolOption false "Create alias for `vi`";
    vimAlias = mkBoolOption false "Create alias for `vim`";
    nvimAlias = mkBoolOption false "Create alias for `nvim`";
  };

  config = {
    user.home.programs.helix = {
      inherit (cfg) enable defaultEditor;

      settings = {
        theme = "catppuccin-mocha";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
        };
        keys.normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          esc = ["collapse_selection" "keep_primary_selection"];
        };
      };

      themes = {
        catppuccin-mocha = builtins.fromTOML (builtins.readFile
          (pkgs.fetchFromGitHub
            {
              owner = "catppuccin";
              repo = "helix";
              rev = "31a29bd9848e239b94fa8151eba4bdc6007d8c69";
              sha256 = "sha256-qEXhj/Mpm+aqThqEq5DlPJD8nsbPov9CNMgG9s4E02g=";
            }
            + /themes/default/catppuccin_mocha.toml));
      };
    };

    user.shellAliases = mkMerge [
      (mkIf cfg.viAlias {vi = "hx";})
      (mkIf cfg.vimAlias {vim = "hx";})
      (mkIf cfg.nvimAlias {nvim = "hx";})
    ];
  };
}
