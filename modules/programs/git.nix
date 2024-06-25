{
  config,
  lib,
  ...
}: let
  inherit (lib.extra) mkEnableOption;

  cfg = config.modules.programs.git;
in {
  options.modules.programs.git = {
    enable = mkEnableOption "Enables the Git VCS.";
  };

  config = {
    user.home.programs.git = {
      inherit (cfg) enable;

      extraConfig = {
        branch.autosetuprebase = "always";
        color.ui = true;
        core.eol = "lf";
        diff.algorithm = "histogram";
        init.defaultBranch = "main";
        pull.rebase = true;
        push.default = "current";
        rebase.autoStash = true;

        url."git@github.com:".insteadOf = "https://github.com/";
      };

      aliases = {
        unstage = "restore --staged";
        uncommit = "reset --soft HEAD~";

        cp = "cherry-pick";

        l = "log --oneline --no-merges";
        ll = "log --graph --topo-order --date=short --abbrev-commit --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset'";
        lll = "log --graph --topo-order --date=iso8601-strict --no-abbrev-commit --abbrev=40 --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn <%ce>]%Creset %Cblue%G?%Creset'";

        save = "stash push -u";
        pop = "stash pop";
      };
    };
  };
}
