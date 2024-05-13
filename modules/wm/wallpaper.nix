{config, ...}: {
  user.home = {
    programs = {
      wpaperd = {
        enable = true;
        settings = {
          default = {
            duration = "2m";
            path = "/home/${config.user.name}/dotfiles/wallpapers";
            sorting = "ascending";
            apply-shadow = false;
          };
        };
      };
    };
  };
}
