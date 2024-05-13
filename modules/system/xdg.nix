{pkgs, ...}: {
  services.dbus.enable = true;

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;

      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };

  environment.systemPackages = [pkgs.xdg-user-dirs pkgs.xdg-utils];
}
