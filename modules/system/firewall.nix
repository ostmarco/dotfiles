{...}: {
  networking = {
    firewall = {
      enable = true;
      allowPing = true;

      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };
}
