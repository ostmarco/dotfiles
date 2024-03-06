{pkgs, ...}: {
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;

      config.common.default = "*";

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };

  # required by xdg-desktop-portal
  services.dbus.enable = true;

  environment.systemPackages = [pkgs.xdg-user-dirs];
}
