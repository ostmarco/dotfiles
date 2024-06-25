{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.programs.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim.plugins.conform-nvim = {
      enable = true;

      formatOnSave = {
        lspFallback = true;
        timeoutMs = 500;
      };

      notifyOnError = true;

      formattersByFt = {
        markdown = [
          ["prettierd" "prettier"]
          "markdownlint"
          "markdown-toc"
        ];
        nix = ["alejandra"];
        rust = ["rustfmt"];
        yaml = ["yamlfmt"];
        zig = ["zigfmt"];
      };
    };
  };
}
