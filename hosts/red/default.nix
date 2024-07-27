{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  environment.systemPackages = with pkgs; [
    arion
    bat
    bintools
    bottom
    btop
    coreutils
    curl
    exfat
    eza
    fastfetch
    file
    fzf
    git
    glib
    jq
    libnotify
    mpv
    openssl
    p7zip
    ripgrep
    tldr
    toybox
    unrar
    unzip
    wget
    zip
  ];

  # Services
  services = {
    gnome.gnome-keyring.enable = true;

    mysql = {
      enable = false;
      package = pkgs.mariadb;
    };

    redis.servers."redis" = {
      enable = true;
      port = 6379;
    };
  };

  programs = {
    adb.enable = true;
    command-not-found.enable = true;
  };

  modules = {
    programs = {
      fish.enable = true;
      git.enable = true;
      kitty.enable = true;

      nixvim = {
        enable = true;

        viAlias = true;
        vimAlias = true;
      };

      zed.enable = true;
    };

    services = {
      docker = {
        enable = true;
        compose = true;
      };

      lgtm.enable = true;

      stylix = {
        enable = true;
        wallpaper = wallpapers/nixos-binary.png;
      };
    };
  };

  # User Account
  user = {
    name = "marco";
    description = "Marco Antônio";

    groups = ["adbusers" "docker" "networking" "video" "wheel" "kvm" "dialout"];

    shellAliases = {
      ls = "exa";
      cat = "bat";
    };

    packages = with pkgs; let
      gcloud = google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        kubectl
      ]);
    in [
      (discord.override {withOpenASAR = true;})
      alejandra
      anydesk
      d2
      devenv
      dotnet-sdk_8
      gcloud
      gh
      jetbrains.datagrip
      jetbrains.rider
      minikube
      nil
      webcord
      nixd
      obsidian
      onlyoffice-bin
      postman
      shfmt
      signal-desktop
      spotify
      stremio
      tor-browser-bundle-bin
      ventoy-full
      zoom-us
      zx
    ];

    home = {
      services.flameshot.enable = true;

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        google-chrome.enable = true;

        vscode = {
          enable = true;
          package = pkgs.vscode.fhs;

          extensions = lib.mkForce [];
          userSettings = lib.mkForce {};
        };
      };
    };
  };
}
