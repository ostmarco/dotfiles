{...}: {
  networking = {
    firewall = let
      ports = [5096];
      onlyTCP = [];
      onlyUDP = [];
    in {
      enable = true;
      allowPing = true;

      allowedTCPPorts = ports ++ onlyTCP;
      allowedUDPPorts = ports ++ onlyUDP;
    };
  };
}
