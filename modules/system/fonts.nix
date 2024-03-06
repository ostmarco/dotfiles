{pkgs, ...}: {
  fonts = {
    fontDir.enable = true;

    enableDefaultPackages = true;

    packages = with pkgs; [
      corefonts
      font-awesome
      nerdfonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      ny
      sf-compact
      sf-mono
      sf-pro
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Iosevka NF" "Noto Sans Mono"];
        serif = ["New York" "Noto Serif" "Source Han Serif"];
        sansSerif = ["SF Pro" "Noto Sans" "Source Han Sans"];
      };
    };
  };
}
