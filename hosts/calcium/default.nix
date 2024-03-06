{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  # Nix
  nix = {
    package = pkgs.nixUnstable;
    settings = {
      trusted-users = ["root" "marco"];
      allowed-users = ["root" "marco"];

      max-jobs = "auto";
      experimental-features = "nix-command flakes";
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
  };

  # Bootloader
  boot = {
    tmp.cleanOnBoot = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.enableRedistributableFirmware = true;

  # Graphics
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    nvidiaSettings = true;
  };

  # Sound
  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
  };

  security.rtkit.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings.General = {
    AutoConnect = "true";
    Enable = "Source,Sink,Media,Socket";
    FastConnectable = "true";
    MultiProfile = "multiple";
  };

  services.blueman.enable = true;

  # Networking
  networking = {
    hostName = "calcium";
    networkmanager.enable = true;
  };

  # Locale
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  # X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "alt-intl";
  };

  # Gnome
  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages =
    (with pkgs; [gnome-photos gnome-tour])
    ++ (with pkgs.gnome; [
      atomix
      cheese
      epiphany
      geary
      gedit
      gnome-characters
      gnome-contacts
      gnome-initial-setup
      gnome-music
      hitori
      iagno
      tali
      yelp
    ]);

  programs.dconf.enable = true;

  # Packages
  environment.systemPackages = with pkgs; [
    # General
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

    # Terminal
    bat
    bottom
    btop
    exa
    fzf
    nitch
    ranger
    tldr

    # Archive Tools
    p7zip
    unrar
    unzip
    zip

    # Gnome
    gnome.gnome-tweaks
  ];

  # User Account
  users.users.marco = {
    description = "Marco Antônio";

    packages = with pkgs; [
      alejandra
      brave
      discord
      nil

      nodejs
      nodePackages.npm
      nodePackages.yarn

      spotify
    ];

    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  # Home Manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.marco = {
    gtk = {
      enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = "palenight";
        package = pkgs.palenight-theme;
      };

      cursorTheme = {
        name = "macOS-Monterey";
        package = pkgs.apple-cursor;
      };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = true;
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/fold-l.webp";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/fold-d.webp";
        primary-color = "#26A269";
      };

      "org/gnome/desktop/interface" = {
        font-antialiasing = "rgba";
      };

      "org/gnome/desktop/screensaver/picture-uri" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/fold-l.webp";
        primary-color = "#26A269";
      };

      "org/gnome/desktop/wm/preferences" = {
        action-double-click-titlebar = "toggle-maximize";
        button-layout = "appmenu:minimize,maximize,close";
      };

      "org/gnome/mutter" = {
        edge-tiling = true;
        dynamic-workspaces = true;
        center-new-windows = true;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
        power-button-action = "interactive";
      };
    };

    programs = {
      alacritty = {
        enable = true;

        settings = {
          window = {
            title = "Alacritty";
            dynamicTitle = true;

            opacity = 1.0;

            startupMode = "Windowed";
          };
          font = {
            normal = {
              family = "FiraCode Nerd Font";
              style = "Regular";
            };

            bold = {
              family = "FiraCode Nerd Font";
              style = "Bold";
            };

            italic = {
              family = "FiraCode Nerd Font";
              style = "Italic";
            };

            boldItalic = {
              family = "FiraCode Nerd Font";
              style = "Bold Italic";
            };

            size = 11.0;
          };
        };
      };
      git = {
        enable = true;

        userName = "Marco Antônio";
        userEmail = "marcodsl@tuta.io";

        aliases = {
          unstage = "reset HEAD --";
          uncommit = "reset --soft HEAD~";
        };

        extraConfig = {
          core = {
            eol = "lf";
          };

          init = {
            defaultBranch = "main";
          };

          pull = {
            rebase = "true";
          };

          push = {
            default = "current";
          };
        };
      };
      neovim = {
        enable = true;

        viAlias = true;
        vimAlias = true;

        defaultEditor = true;
      };
      vscode = {
        enable = true;

        userSettings = {
          # Code
          "workbench.colorTheme" = "Afterglow Remastered";
          "workbench.tree.indent" = 20;
          "workbench.editor.highlightModifiedTabs" = true;

          "editor.minimap.enabled" = false;
          "editor.rulers" = [80 120];

          "editor.fontFamily" = "FiraCode Nerd Font";
          "editor.fontSize" = 13;
          "editor.tabSize" = 4;

          "editor.renderWhitespace" = "trailing";

          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;

          "terminal.integrated.fontSize" = 13;

          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;

          "editor.lineNumbers" = "relative";

          "errorLens.messageMaxChars" = 80;
          "errorLens.onSaveTimeout" = 2000;

          "files.eol" = "\n";

          "files.exclude" = {
            "**/.git" = true;
            "**/.svn" = true;
            "**/.hg" = true;
            "**/CVS" = true;
            "**/.DS_Store" = true;
            "**/Thumbs.db" = true;
            "**/node_modules" = true;
          };

          # Nix Language Server
          "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [
                  "alejandra"
                ];
              };
            };
          };
        };

        extensions =
          (with pkgs.vscode-extensions; [
            dbaeumer.vscode-eslint
            eamodio.gitlens
            editorconfig.editorconfig
            esbenp.prettier-vscode
            github.copilot
            github.github-vscode-theme
            jnoortheen.nix-ide
            usernamehw.errorlens
          ])
          ++ (with pkgs.vscode-utils; [
            (extensionFromVscodeMarketplace {
              name = "theme-afterglow-remastered";
              publisher = "marvinhagemeister";
              version = "1.1.3";
              sha256 = "sha256-LRua4gawRs3BUox1Qx40fCNLRcluxf4mIo5TYaWSzQQ=";
            })
          ]);
      };
    };

    home.file.".XCompose".text = ''
      include "/%L"

      <dead_acute> <c> : "ç"
      <dead_acute> <C> : "Ç"
    '';

    home.sessionVariables.GTK_THEME = "palenight";

    home.stateVersion = "23.05";
  };

  # Fonts
  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  system.stateVersion = "23.05";
}
