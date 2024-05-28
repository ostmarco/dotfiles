{...}: {
  networking.networkmanager.enable = true;
  networking.nameservers = ["8.8.8.8" "8.8.4.4"];

  services.mullvad-vpn.enable = false;
}
