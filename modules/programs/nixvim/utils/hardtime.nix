{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.programs.nixvim;
in {
  config = mkIf cfg.enable {
    programs.nixvim.plugins.hardtime = {
      enable = true;
      enabled = true;

      disableMouse = true;
      disabledFiletypes = ["Oil"];

      hint = true;

      maxTime = 1000;
      maxCount = 4;

      restrictionMode = "hint";
      restrictedKeys = {
        "h" = ["n" "x"];
        "j" = ["n" "x"];
        "k" = ["n" "x"];
        "l" = ["n" "x"];
        "-" = ["n" "x"];
        "+" = ["n" "x"];
        "gj" = ["n" "x"];
        "gk" = ["n" "x"];
        "<CR>" = ["n" "x"];
        "<C-M>" = ["n" "x"];
        "<C-N>" = ["n" "x"];
        "<C-P>" = ["n" "x"];
      };
    };
  };
}
