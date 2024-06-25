{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.programs.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim.opts = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      softtabstop = 2;
      showtabline = 2;
      expandtab = true;

      smartindent = true; # auto indenting
      shiftwidth = 2; # set tabs to 2 spaces

      breakindent = true; # smart indenting

      hlsearch = true; # incremental searching
      incsearch = true; # incremental searching

      wrap = true; # text wrap

      splitbelow = true;
      splitright = true;

      mouse = "a";

      updatetime = 50; # decrease updatetime, faster completion (4000ms default)

      completeopt = ["menuone" "noselect" "noinsert"];

      swapfile = false;
      backup = false;
      undofile = true;

      timeoutlen = 10;

      termguicolors = true;

      cursorline = true; # enable cursor line highlight

      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      scrolloff = 8;

      encoding = "utf-8";
      fileencoding = "utf-8";

      cmdheight = 0;
    };
  };
}
