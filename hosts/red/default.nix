{
  pkgs,
  inputs,
  system,
  ...
}: let
  vscode-extensions = inputs.nix-vscode-extensions.extensions.${system};
in {
  imports = [./hardware.nix];

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

  programs.adb.enable = true;

  modules.programs = {
    fish.enable = true;
    git.enable = true;
    kitty.enable = true;

    helix = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      nvimAlias = true;
    };
  };

  modules.services = {
    docker.enable = true;
  };

  # User Account
  user = {
    name = "marco";
    description = "Marco Antônio";

    groups = ["adbusers" "docker" "networking" "video" "wheel"];

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
      alejandra
      d2
      dotnet-sdk_8
      flameshot
      gcloud
      gh
      gtk-engine-murrine
      jetbrains.datagrip
      jetbrains.rider
      jetbrains.webstorm
      logseq
      minikube
      nicotine-plus
      nil
      obsidian
      onlyoffice-bin
      postman
      signal-desktop
      spotify
      stremio
      terraform
      tor-browser-bundle-bin
      ventoy-full
      vesktop
    ];

    home.programs = {
      google-chrome.enable = true;

      vscode = {
        enable = true;

        userSettings = {
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "Catppuccin Mocha";
          "workbench.tree.indent" = 12;
          "workbench.editor.highlightModifiedTabs" = true;

          "window.zoomLevel" = 0;

          "symbols.hidesExplorerArrows" = false;

          "editor.minimap.enabled" = false;
          "editor.rulers" = [80 120];

          "workbench.startupEditor" = "newUntitledFile";
          "workbench.editor.labelFormat" = "short";

          "explorer.compactFolders" = false;

          "editor.fontFamily" = "Iosevka Comfy Motion";
          "editor.fontSize" = 14;
          "editor.fontLigatures" = true;

          "editor.lineHeight" = 1.8;
          "editor.lineNumbers" = "relative";

          "editor.tabSize" = 4;

          "editor.renderWhitespace" = "trailing";
          "editor.renderLineHighlight" = "gutter";

          "editor.semanticHighlighting.enabled" = false;

          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;

          "terminal.integrated.fontFamily" = "Iosevka Comfy Motion";
          "terminal.integrated.fontSize" = 13;
          "terminal.integrated.defaultProfile.linux" = "fish";

          "files.autoSave" = "afterDelay";
          "files.autoSaveDelay" = 1000;

          "editor.inlineSuggest.enabled" = true;

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

          # Rust
          "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";

          # Shell + Dockerfile + ignore
          "[shellscript]"."editor.defaultFormatter" = "foxundermoon.shell-format";
          "[dockerfile]"."editor.defaultFormatter" = "foxundermoon.shell-format";
          "[ignore]"."editor.defaultFormatter" = "foxundermoon.shell-format";
          "shellformat.path" = "${pkgs.shfmt}/bin/shfmt";

          # Terraform
          "[terraform]"."editor.defaultFormatter" = "hashicorp.terraform";
        };

        mutableExtensionsDir = false;

        extensions = (
          with vscode-extensions.vscode-marketplace; [
            arrterian.nix-env-selector
            catppuccin.catppuccin-vsc
            catppuccin.catppuccin-vsc-icons
            dbaeumer.vscode-eslint
            eamodio.gitlens
            editorconfig.editorconfig
            esbenp.prettier-vscode
            foxundermoon.shell-format
            github.copilot
            github.copilot-chat
            github.vscode-pull-request-github
            github.vscode-github-actions
            hashicorp.terraform
            jnoortheen.nix-ide
            ms-azuretools.vscode-docker
            ms-vscode.live-server
            ms-vsliveshare.vsliveshare
            rust-lang.rust-analyzer
            tamasfe.even-better-toml
            terrastruct.d2
            timonwong.shellcheck
            tomoki1207.pdf
            usernamehw.errorlens
            vue.volar
          ]
        );
      };
    };

    sessionVariables = {
      GTK_THEME = "Catppuccin-Mocha-Compact-Lavender-Dark";
    };

    home.extraConfig = {
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
          name = "Catppuccin-Mocha-Dark-Cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
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
}
