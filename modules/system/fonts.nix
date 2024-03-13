{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;

    enableDefaultPackages = true;

    packages = with pkgs; let
      mkZedFont = name: hash:
        stdenv.mkDerivation rec {
          inherit name;
          version = "1.2.0";

          src = fetchzip {
            inherit hash;

            url = "https://github.com/zed-industries/zed-fonts/releases/download/${version}/${name}-${version}.zip";
            stripRoot = false;
          };

          installPhase = ''
            runHook preInstall

            install -Dm644 *.ttf -t $out/share/fonts/truetype

            runHook postInstall
          '';
        };

      zed-mono = mkZedFont "zed-mono" "sha256-k9N9kWK2JvdDlGWgIKbRTcRLMyDfYdf3d3QTlA1iIEQ=";
      zed-sans = mkZedFont "zed-sans" "sha256-BF18dD0UE8Q4oDEcCf/mBkbmP6vCcB2vAodW6t+tocs=";
    in [
      corefonts
      font-awesome
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      ny
      sf-mono
      sf-pro
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese

      zed-mono
      zed-sans
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Zed Mono" "Noto Sans Mono"];
        serif = ["New York" "Noto Serif" "Source Han Serif"];
        sansSerif = ["Zed Sans" "Noto Sans" "Source Han Sans"];
      };
    };
  };
}
