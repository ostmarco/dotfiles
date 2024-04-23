{
  config,
  pkgs,
  ...
}: let
  modifier = "Mod4";
  terminal = "${pkgs.kitty}/bin/kitty";
  menu = "${pkgs.rofi}/bin/rofi";

  left = "h";
  down = "j";
  up = "k";
  right = "l";

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      systemctl --user import DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
      dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  importGsettings = let
    gsettings = "${pkgs.glib}/bin/gsettings";
    gnomeSchema = "org.gnome.desktop.interface";
  in
    pkgs.writeShellScript "import-gsettings.sh" ''
      CONFIG_FILE="/home/${config.user.name}/.config/gtk-3.0/settings.ini"

      if [ ! -f "$CONFIG_FILE" ]; then
        exit 1;
      fi

      GTK_THEME="$(grep 'gtk-theme-name' "$CONFIG_FILE" | sed 's/.*\s*=\s*//')"
      ICON_THEME="$(grep 'gtk-icon-theme-name' "$CONFIG_FILE" | sed 's/.*\s*=\s*//')"
      CURSOR_THEME="$(grep 'gtk-cursor-theme-name' "$CONFIG_FILE" | sed 's/.*\s*=\s*//')"
      FONT_NAME="$(grep 'gtk-font-name' "$CONFIG_FILE" | sed 's/.*\s*=\s*//')"

      ${gsettings} set ${gnomeSchema} gtk-theme "$GTK_THEME"
      ${gsettings} set ${gnomeSchema} icon-theme "$ICON_THEME"
      ${gsettings} set ${gnomeSchema} cursor-theme "$CURSOR_THEME"
      ${gsettings} set ${gnomeSchema} font-name "$FONT_NAME"
    '';
in {
  security.polkit.enable = true;

  programs.light.enable = true;
  programs.wshowkeys.enable = true;

  user.sessionVariables = {
    # Session
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "sway";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_CURRENT_SESSION = "sway";

    # Wayland
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_USE_XINPUT2 = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
  };

  environment.systemPackages = with pkgs; [
    dbus-sway-environment
    grim
    pcmanfm
    shotman
    slurp
    swaybg
    swaylock-effects
    wdisplays
    wl-clipboard
    wlr-randr
  ];

  user.home = {
    programs.rofi = {
      enable = true;
      terminal = terminal;
      font = "Zed Sans 14";
      theme = let
        inherit (config.home-manager.users.${config.user.name}.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          bg-col = mkLiteral "#24273a";
          bg-col-light = mkLiteral "#24273a";
          border-col = mkLiteral "#24273a";
          selected-col = mkLiteral "#24273a";
          blue = mkLiteral "#8aadf4";
          fg-col = mkLiteral "#cad3f5";
          fg-col2 = mkLiteral "#ed8796";
          grey = mkLiteral "#6e738d";

          width = 600;
        };

        "element-text, element-icon , mode-switcher" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "window" = {
          height = mkLiteral "360px";
          border = mkLiteral "3px";
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
        };

        "mainbox" = {
          background-color = mkLiteral "@bg-col";
        };

        "inputbar" = {
          children = mkLiteral "[prompt,entry]";
          background-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "5px";
          padding = mkLiteral "2px";
        };

        "prompt" = {
          background-color = mkLiteral "@blue";
          padding = mkLiteral "6px";
          text-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "3px";
          margin = mkLiteral "20px 0px 0px 20px";
        };

        "textbox-prompt-colon" = {
          expand = false;
          str = "=";
        };

        "entry" = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 10px";
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "@bg-col";
        };

        "listview" = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "6px 0px 0px";
          margin = mkLiteral "10px 0px 0px 20px";
          columns = 2;
          lines = 5;
          background-color = mkLiteral "@bg-col";
        };

        "element" = {
          padding = mkLiteral "5px";
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@fg-col ";
        };

        "element-icon" = {
          size = mkLiteral "25px";
        };

        "element selected" = {
          background-color = mkLiteral "@selected-col";
          text-color = mkLiteral "@fg-col2";
        };

        "mode-switcher" = {
          spacing = 0;
        };

        "button" = {
          padding = mkLiteral "10px";
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@grey";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@blue";
        };

        "message" = {
          background-color = mkLiteral "@bg-col-light";
          margin = mkLiteral "2px";
          padding = mkLiteral "2px";
          border-radius = mkLiteral "5px";
        };

        "textbox" = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 20px";
          text-color = mkLiteral "@blue";
          background-color = mkLiteral "@bg-col-light";
        };
      };

      extraConfig = {
        modi = "run,drun,window";
        icon-theme = "Oranchelo";
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " 﩯 Window";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        ignore-empty-password = true;

        font-size = 24;
        font = "Zed Sans";

        clock = true;

        indicator-radius = 100;
        indicator-idle-visible = true;
        show-failed-attempts = true;

        color = "1e1e2e";
        bs-hl-color = "f5e0dc";
        caps-lock-bs-hl-color = "f5e0dc";
        caps-lock-key-hl-color = "a6e3a1";
        inside-color = "00000000";
        inside-clear-color = "00000000";
        inside-caps-lock-color = "00000000";
        inside-ver-color = "00000000";
        inside-wrong-color = "00000000";
        key-hl-color = "a6e3a1";
        layout-bg-color = "00000000";
        layout-border-color = "00000000";
        layout-text-color = "cdd6f4";
        line-color = "00000000";
        line-clear-color = "00000000";
        line-caps-lock-color = "00000000";
        line-ver-color = "00000000";
        line-wrong-color = "00000000";
        ring-color = "b4befe";
        ring-clear-color = "f5e0dc";
        ring-caps-lock-color = "fab387";
        ring-ver-color = "b4befe";
        ring-wrong-color = "eba0ac";
        separator-color = "00000000";
        text-color = "cdd6f4";
        text-clear-color = "f5e0dc";
        text-caps-lock-color = "fab387";
        text-ver-color = "b4befe";
        text-wrong-color = "eba0ac";
      };
    };

    programs.i3status-rust = {
      enable = true;
      bars = {
        bottom = {
          theme = "native";
          blocks = [
            {
              block = "memory";
              format = " $icon $mem_used_percents ";
              format_alt = " $icon $swap_used_percents ";
            }
            {
              block = "cpu";
              interval = 1;
              format = " $barchart $utilization $frequency ";
            }
            {
              block = "sound";
            }
            {
              block = "battery";
              device = "BAT0";
              format = " $icon $percentage $time $power ";
            }
            {
              block = "net";
              format = " $icon $ssid $signal_strength $ip ↓$speed_down ↑$speed_up ";
              interval = 2;
            }
            {
              block = "time";
              interval = 1;
              format = " $timestamp.datetime(f:'%F %T') ";
            }
          ];
        };
      };
    };

    services.mako = {
      enable = true;
      defaultTimeout = 10000;

      extraConfig = ''
        background-color=#1e1e2e
        text-color=#cdd6f4
        border-color=#b4befe
        progress-color=over #313244

        [urgency=high]
        border-color=#fab387
      '';
    };

    extraConfig.wayland.windowManager.sway = let
      theme = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#b4befe";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };
    in {
      enable = true;

      wrapperFeatures = {
        base = true;
        gtk = true;
      };

      config = {
        modifier = modifier;
        terminal = terminal;

        startup = [
          {command = "${importGsettings}";}
          {command = "bluetoothctl power on";}
          {command = "nohup flameshot &";}
          {command = "wpaperd";}
        ];

        gaps.inner = 15;
        window.titlebar = false;

        bars = [
          {
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-bottom.toml";
            colors = let
              mkColorSet = border: background: text: {inherit border background text;};
            in {
              background = theme.base;
              statusline = theme.text;
              focusedStatusline = theme.text;
              focusedSeparator = theme.overlay0;
              focusedWorkspace = mkColorSet theme.base theme.base theme.green;
              activeWorkspace = mkColorSet theme.base theme.base theme.blue;
              inactiveWorkspace = mkColorSet theme.base theme.base theme.surface1;
              urgentWorkspace = mkColorSet theme.base theme.base theme.surface1;
              bindingMode = mkColorSet theme.base theme.base theme.surface1;
            };
          }
        ];

        input = {
          "1:1:AT_Translated_Set_2_keyboard" = {
            "xkb_layout" = "br";
            "xkb_variant" = "abnt2";
          };

          "1133:50504:Logitech_USB_Receiver" = {
            "xkb_layout" = "us";
            "xkb_variant" = "alt-intl";
          };

          "type:touchpad" = {
            "tap" = "enabled";
            "natural_scroll" = "enabled";
          };
        };

        floating.criteria = [
          {app_id = ".blueman-manager-wrapped";}
          {app_id = "pcmanfm";}
        ];

        keybindings = {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+q" = "kill";
          "${modifier}+space" = "exec ${menu} -show drun";
          "XF86Search" = "exec pcmanfm";

          "${modifier}+Shift+s" = "exec ${pkgs.shotman}/bin/shotman --capture region";

          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${right}" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          # "${modifier}+space" = "focus mode_toggle";

          "${modifier}+period" = "workspace next";
          "${modifier}+comma" = "workspace prev";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";

          "${modifier}+Shift+period" = "move container to workspace next; workspace next";
          "${modifier}+Shift+comma" = "move container to workspace prev; workspace prev";

          "${modifier}+tab" = "workspace next_on_output";
          "Alt+tab" = "workspace back_and_forth";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+r" = "mode resize";

          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";

          "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1 @DEFAULT_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume -l 1 @DEFAULT_SINK@ 5%-";

          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_SOURCE@ toggle";
        };
      };

      extraSessionCommands = ''
        eval $(gnome-keyring-daemon --start --components=secrets);
      '';

      extraConfig = ''
        client.focused           ${theme.lavender} ${theme.base} ${theme.text}  ${theme.rosewater} ${theme.lavender}
        client.focused_inactive  ${theme.overlay0} ${theme.base} ${theme.text}  ${theme.rosewater} ${theme.overlay0}
        client.unfocused         ${theme.overlay0} ${theme.base} ${theme.text}  ${theme.rosewater} ${theme.overlay0}
        client.urgent            ${theme.peach}    ${theme.base} ${theme.peach} ${theme.overlay0}  ${theme.peach}
        client.placeholder       ${theme.overlay0} ${theme.base} ${theme.text}  ${theme.overlay0}  ${theme.overlay0}
        client.background        ${theme.base}

        # Monitors
        set $PRIMARY "HDMI-A-1"
        set $FALLBACK "eDP-1"

        workspace 1 output $PRIMARY $FALLBACK
        workspace 2 output $PRIMARY $FALLBACK
        workspace 3 output $PRIMARY $FALLBACK
        workspace 4 output $PRIMARY $FALLBACK
        workspace 5 output $PRIMARY $FALLBACK
        workspace 6 output $PRIMARY $FALLBACK
        workspace 7 output $PRIMARY $FALLBACK
        workspace 8 output $PRIMARY $FALLBACK
        workspace 9 output $PRIMARY $FALLBACK
      '';

      # for_window [app_id="flameshot"] border pixel 0, floating enable, fullscreen disable, move absolute position 0 0

      swaynag.enable = true;
    };
  };
}
