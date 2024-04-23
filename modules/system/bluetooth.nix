{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        AutoConnect = "true";
        Enable = "Source,Sink,Media,Socket";
        FastConnectable = "true";
        MultiProfile = "multiple";
      };
    };
  };

  services.blueman.enable = true;

  systemd.user.services.mpris-proxy = {
    description = "MPRIS Proxy";
    after = ["network.target" "sound.target"];
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      RestartSec = 5;
      Restart = "always";
    };
  };
}
