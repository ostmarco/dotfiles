{...}: {
  user.home = {
    programs = {
      wpaperd = {
        enable = true;
        settings = {
          default = {
            duration = "2m";
            path = /home/marco/.dotfiles/wallpapers;
            sorting = "ascending";
            apply-shadow = false;
          };
        };
      };
    };
  };
}
