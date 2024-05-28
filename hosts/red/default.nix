{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  # Programs
  programs.command-not-found.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    #
    bind
    bintools
    coreutils
    curl
    file
    git
    git-crypt
    killall
    parted
    ripgrep
    wget

    bat
    bottom
    btop
    eza
    fzf
    mpv
    nitch
    tldr

    p7zip
    unrar
    unzip
    zip

    libnotify

    zx

    glib

    shfmt
    docker-compose
  ];

  # Services
  services.redis.servers = {
    "redis" = {
      enable = true;
      port = 6379;
    };
  };

  services.mysql = {
    enable = false;
    package = pkgs.mariadb;
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    adb.enable = true;

    nixvim = {
      enable = true;

      clipboard.providers.wl-copy.enable = true;

      plugins = {
        bufferline.enable = true;
        comment.enable = true;
        lualine.enable = true;
        oil.enable = true;
        telescope.enable = true;
        treesitter.enable = true;
      };

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          color_overrides.mocha.accent = "#b4befe";
          flavour = "mocha";
          styles = {
            booleans = [
              "bold"
              "italic"
            ];
            conditionals = [
              "bold"
            ];
          };
          term_colors = true;
        };
      };
    };
  };

  modules = {
    programs = {
      fish.enable = true;
      git.enable = true;
      kitty.enable = true;

      helix = {
        enable = true;
        # defaultEditor = true;

        # viAlias = true;
        # vimAlias = true;
        # nvimAlias = true;
      };
    };

    services = {
      docker.enable = true;
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

    sessionVariables = {
      GTK_THEME = "Catppuccin-Mocha-Compact-Lavender-Dark";
    };

    packages = with pkgs; let
      gcloud = google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        kubectl
      ]);
    in [
      alejandra
      d2
      devenv
      gcloud
      gh
      jetbrains.datagrip
      jetbrains.rider
      minikube
      nil
      obsidian
      onlyoffice-bin
      postman
      signal-desktop
      spotify
      stremio
      tor-browser-bundle-bin
      vesktop
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
        };
      };

      extraConfig = let
        cursor = {
          name = "Catppuccin-Mocha-Dark-Cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
        };
      in {
        xsession = {
          enable = true;
          pointerCursor = {
            name = cursor.name;
            package = cursor.package;
            size = 24;
          };
        };

        gtk = {
          enable = true;

          font = {
            name = "Iosevka Comfy Motion";
            size = 10;
          };

          theme = {
            name = "Catppuccin-Mocha-Compact-Lavender-Dark";
            package = pkgs.catppuccin-gtk.override {
              accents = ["lavender"];
              size = "compact";
              tweaks = ["rimless"];
              variant = "mocha";
            };
          };

          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.catppuccin-papirus-folders;
          };

          cursorTheme = {
            name = cursor.name;
            package = cursor.package;
          };

          gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = true;
          };

          gtk4.extraConfig = {
            gtk-application-prefer-dark-theme = true;
          };
        };
      };
    };
  };
}
