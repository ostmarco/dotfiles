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
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

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
  ];

  # User Account
  users.users.marco = {
    description = "Marco Antônio";

    packages = with pkgs; [
      alejandra
      discord
      firefox
      nil
      spotify
    ];

    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
  };

  # Home Manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home-manager.users.marco = {
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
          "editor.fontSize" = 13;
          "editor.tabSize" = 4;
          "editor.renderWhitespace" = "trailing";
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
            eamodio.gitlens
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

    home.stateVersion = "23.05";
  };

  # Fonts
  fonts.fonts = with pkgs; [
    nerdfonts
  ];

  system.stateVersion = "23.05";
}
