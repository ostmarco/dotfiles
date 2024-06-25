{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    package = pkgs.bluez-experimental;

    disabledPlugins = ["sap"];

    settings = {
      General = {
        AutoConnect = "true";
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = "true";
        MultiProfile = "multiple";
        JustWorksRepairing = "always";
      };
    };
  };

  services.blueman.enable = true;

  services.pipewire.wireplumber = {
    configPackages = let
      mkConfigPackage = name: cfg: (
        pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/${name}.conf" cfg
      );
    in [
      (mkConfigPackage "11-bluetooth-policy" ''
        wireplumber.settings = {
          bluetooth.autoswitch-to-headset-profile = false
        }
      '')
    ];
  };

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
