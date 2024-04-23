{...}: {
  networking.networkmanager.enable = true;

  services.mullvad-vpn.enable = false;
}
