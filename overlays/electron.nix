final: let
  enableWayland = drv: bin:
    drv.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.makeWrapper];
      postFixup =
        (old.postFixup or "")
        + ''
          wrapProgram $out/bin/${bin} \
            --add-flags "--enable-features=UseOzonePlatform" \
            --add-flags "--enable-webrtc-pipewire-capturer" \
            --add-flags "--ozone-platform=wayland"
        '';
    });
in
  prev: {
    discord = enableWayland prev.discord "discord";
  }
