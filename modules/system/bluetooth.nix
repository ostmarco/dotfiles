{pkgs, ...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        AutoConnect = "true";
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
        FastConnectable = "true";
        MultiProfile = "multiple";
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

      (mkConfigPackage "50-bluez" ''
        monitor.bluez.rules = [
          {
            matches = [
              {
                ## This matches all bluetooth devices.
                device.name = "~bluez_card.*"
              }
            ]
            actions = {
              update-props = {
                bluez5.auto-connect = [ a2dp_sink ]
                bluez5.hw-volume = [ a2dp_sink ]
              }
            }
          }
        ]

        monitor.bluez.properties = {
          bluez5.roles = [ a2dp_sink ]
          bluez5.hfphsp-backend = "none"
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
