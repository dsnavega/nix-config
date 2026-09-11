{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  xresources.properties = lib.optionalAttrs (osConfig.services.xserver.dpi != null) {
    "Xft.dpi" = osConfig.services.xserver.dpi;
  };
  xsession.windowManager.i3 = {
    enable = true;

    config = {

      startup =
        lib.optionals (osConfig.networking.hostName == "strix") [
          {
            # panel is 240Hz; drop to 60Hz to cut idle power draw
            command = "xrandr --output eDP-1 --mode 2560x1600 --rate 60";
            always = true;
            notification = false;
          }
        ]
        ++ [
          {
            # wallpaper
            command = "hsetroot -solid \"${colors.base00}\"";
            always = true;
            notification = false;
          }
          {
            # polkit
            command = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
            notification = false;
          }
          {
            # secrets
            command = "kwalletd6";
            notification = false;
          }
          {
            # kde daemon
            command = "kded6";
            notification = false;
          }
          {
            # xresources
            command = "${pkgs.xrdb}/bin/xrdb -merge ${config.xresources.path}";
            always = true;
            notification = false;
          }
          {
            # idle behaviour on by default; toggle with the system mode's `i` key
            command = "~/.config/i3/idle-toggle.sh";
            notification = false;
          }
          {
            # lock the screen before suspend/sleep (any path: keybinding,
            # `systemctl suspend`, or a future lid-switch re-enable)
            command = "xss-lock -- ~/.config/i3/i3lock.sh";
            notification = false;
          }
          {
            command = "alacritty --daemon";
            notification = false;
          }
          {
            command = "clipse -listen";
          }
        ];

      keybindings = {

        # utilities
        "Mod4+Return" = "exec alacritty msg create-window";
        "Mod4+v" = "exec alacritty msg create-window --class clipse -e \"clipse\"";
        "Mod4+space" = "exec rofi -show drun";
        "Mod4+d" = "exec --no-startup-id ~/.config/i3/dmenu_run.sh";
        "Mod4+x" = "exec --no-startup-id ~/.config/i3/i3lock.sh";
        "Print" = "exec --no-startup-id flameshot gui";
        "Mod4+t" = "scratchpad show";

        # window management
        "Mod4+q" = "kill";

        # focus & move
        "Mod4+Left" = "focus left";
        "Mod4+Down" = "focus down";
        "Mod4+Up" = "focus up";
        "Mod4+Right" = "focus right";

        "Mod4+Shift+Left" = "move left";
        "Mod4+Shift+Down" = "move down";
        "Mod4+Shift+Up" = "move up";
        "Mod4+Shift+Right" = "move right";

        # layout
        "Mod4+m" = "fullscreen toggle";
        "Mod4+Shift+f" = "floating toggle";
        "Mod4+f" = "focus mode_toggle";
        "Mod4+a" = "focus parent";

        # workspaces,
        "Control+Left" = "workspace prev";
        "Control+Right" = "workspace next";

        "Mod4+1" = "workspace \"1\"";
        "Mod4+2" = "workspace \"2\"";
        "Mod4+3" = "workspace \"3\"";
        "Mod4+4" = "workspace \"4\"";
        "Mod4+5" = "workspace \"5\"";
        "Mod4+6" = "workspace \"6\"";
        "Mod4+7" = "workspace \"7\"";
        "Mod4+8" = "workspace \"8\"";
        "Mod4+9" = "workspace \"9\"";
        "Mod4+0" = "workspace \"10\"";

        "Mod4+Shift+1" = "move container to workspace number \"1\"; workspace number \"1\"";
        "Mod4+Shift+2" = "move container to workspace number \"2\"; workspace number \"2\"";
        "Mod4+Shift+3" = "move container to workspace number \"3\"; workspace number \"3\"";
        "Mod4+Shift+4" = "move container to workspace number \"4\"; workspace number \"4\"";
        "Mod4+Shift+5" = "move container to workspace number \"5\"; workspace number \"5\"";
        "Mod4+Shift+6" = "move container to workspace number \"6\"; workspace number \"6\"";
        "Mod4+Shift+7" = "move container to workspace number \"7\"; workspace number \"7\"";
        "Mod4+Shift+8" = "move container to workspace number \"8\"; workspace number \"8\"";
        "Mod4+Shift+9" = "move container to workspace number \"9\"; workspace number \"9\"";
        "Mod4+Shift+0" = "move container to workspace number \"10\"; workspace number \"10\"";

        # brightness control
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set 5%+";
        # sound control
        "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioMicMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        # media control
        "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
        "XF86AudioNext" = "exec --no-startup-id playerctl next";
        "XF86AudioPrev" = "exec --no-startup-id playerctl previous";

        # modes
        "Mod4+r" = "mode \" :resize\"";
        "Mod4+p" = "mode \" :system\"";
        "Mod4+l" = "mode \" :layout\"";
      };

      modes." :resize" = {
        Left = "resize shrink width 10 px or 10 ppt";
        Right = "resize grow width 10 px or 10 ppt";
        Up = "resize grow height 10 px or 10 ppt";
        Down = "resize shrink height 10 px or 10 ppt";

        Return = "mode 'default'";
        Escape = "mode \"default\"";
        "Mod4+r" = "mode \"default\"";
      };

      modes." :system" = {
        r = "exec notify-send \" : Reload Configuration\"; reload; restart";
        q = "exec \"i3-msg exit\"";
        l = "exec --no-startup-id ~/.config/i3/i3lock.sh";
        s = "exec --no-startup-id systemctl suspend";
        i = "exec --no-startup-id ~/.config/i3/idle-toggle.sh";

        Return = "mode \"default\"";
        Escape = "mode \"default\"";
        "Mod4+p" = "mode \"default\"";
      };

      modes." :layout" = {
        h = "split h";
        v = "split v";
        s = "layout stacking";
        w = "layout tabbed";
        e = "layout toggle split";

        Return = "mode \"default\"";
        Escape = "mode \"default\"";
        "Mod4+l" = "mode \"default\"";
      };

      focus = {
        newWindow = "smart";
        wrapping = "force";
        mouseWarping = true;
      };

      workspaceAutoBackAndForth = true;
      defaultWorkspace = "workspace \"1\"";

      window = {
        titlebar = false;
        border = 1;
        hideEdgeBorders = "smart";
      };

      floating = {
        modifier = "Mod4";
        titlebar = false;
        border = 1;
      };

      colors.focused.background = lib.mkForce colors.base02;
      colors.focusedInactive.background = lib.mkForce colors.base01;

      gaps = {
        inner = 10;
        outer = 5;
        smartGaps = "on";
        smartBorders = "on";
      };

      bars = [
        (
          {
            statusCommand = "i3status";
          }
          // config.stylix.targets.i3.exportedBarConfig
          // {
            fonts = {
              names = [ "Hack Nerd Font" ];
              size = config.stylix.fonts.sizes.desktop * 1.0;
            };
          }
        )
      ];

    };

    extraConfig = ''
      for_window [class="^.*"] title_format " "
      for_window [class="^clipse$"] floating enable, move position center
    '';
  };

  # notification
  services.dunst.enable = true;
  stylix.targets.dunst.enable = true;

  # compositor
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    fade = true;
    fadeDelta = 4;
    shadow = false;
  };

  # i3status
  home.file.".config/i3status/config" = {
    text = ''
      # ~/.config/i3status/config

      general {
          colors = true
          color_good = "${colors.base0B}"
          color_degraded = "${colors.base0A}"
          color_bad = "${colors.base08}"
          interval = 5
          separator = "  "
      }

      order += "wireless _first_"
      order += "tztime local"
      order += "disk"
      order += "memory"
      order += "cpu_usage"
      order += "volume master"
      order += "battery all"

      volume master {
          format = "  %volume "
          format_muted = "  Muted "
          device = "default"
          mixer = "Master"
          mixer_idx = 0
      }

      wireless _first_ {
          format_up = "  %essid "
          format_down = "󱖣  Off "
      }

      disk "/" {
          format = "  %used "
      }

      cpu_usage {
          format = "  %usage "
      }

      memory {
          format = "  %used "

          threshold_degraded = "10%"
          format_degraded = "  %available "

      }

      battery all {
          format = " %status %remaining %consumption "
          format_down = ""
          status_idle = ""
          status_chr = ""
          status_bat = ""
          status_unk = ""
          status_full = ""
          low_threshold = 15
          threshold_type = time
          last_full_capacity = true
          hide_seconds = true
      }

      tztime local {
          format = "  %H:%M  %d/%m/%Y "
      }

    '';
  };

  home.file.".config/i3/i3lock.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Colors (from Stylix's generated palette)
      BLANK='#00000000'
      CLEAR='#ffffff22'
      DEFAULT='${colors.base0D}ff'
      TEXT='${colors.base05}ff'
      WRONG='${colors.base08}ff'
      VERIFYING='${colors.base0B}ff'
      HIGHLIGHT='${colors.base0C}ff'
      BACKGROUND='${colors.base00}ff'

      FONT="${config.stylix.fonts.monospace.name}"

      # Turn the screen off if still locked after 5 min. Armed on every
      # lock (keybinding, xss-lock, systemctl suspend), independent of
      # idle-toggle.sh. Any key/mouse wakes back to the lock prompt.
      LOCK_TIMEOUT=300
      xset +dpms >/dev/null 2>&1
      ( sleep "$LOCK_TIMEOUT"; pgrep -x i3lock >/dev/null && xset dpms force off ) &
      TIMER_PID=$!
      trap 'kill "$TIMER_PID" 2>/dev/null' EXIT

      i3lock \
        --color=$BACKGROUND --blur=5 \
        --insidever-color=$CLEAR --ringver-color=$VERIFYING \
        --insidewrong-color=$CLEAR --ringwrong-color=$WRONG \
        --inside-color=$BLANK --ring-color=$DEFAULT --line-color=$BLANK --separator-color=$DEFAULT \
        --verif-color=$TEXT --wrong-color=$TEXT --time-color=$TEXT --date-color=$TEXT --layout-color=$TEXT \
        --greeter-color=$TEXT --lock-color=$TEXT \
        --keyhl-color=$HIGHLIGHT --bshl-color=$WRONG \
        --clock --indicator \
        --time-str="%H:%M" --date-str="%d/%m/%Y" \
        --time-pos="ix:iy-60" --date-pos="tx:ty+80" --greeter-pos="ix:iy+420" \
        --time-font="$FONT" --date-font="$FONT" --verif-font="$FONT" --wrong-font="$FONT" \
        --greeter-font="$FONT" --lock-font="$FONT" \
        --time-size=120 --date-size=40 --verif-size=40 --wrong-size=40 --greeter-size=35 --lock-size=35 \
        --radius=360 --ring-width=32 \
        --greeter-text=" Screen Locked" \
        --lock-text=" Screen Locked" --lockfailed-text=" Lock failed" \
        --verif-text=" Verifying..." --wrong-text=" Denied — Enter Password" --noinput-text=" Enter Password"

      trap - EXIT
      kill "$TIMER_PID" 2>/dev/null
    '';
  };

  home.file.".config/i3/idle-toggle.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Toggles idle behaviour: after 5 minutes idle, turn the screen off and
      # mute audio; unmute automatically on resume (screen wakes on its own).
      # Skips the timer entirely while fullscreen (video) or audio is playing.
      TIMEOUT=300

      if pgrep -x xidlehook >/dev/null; then
        pkill -x xidlehook
        notify-send "Idle behaviour" "Disabled"
      else
        xidlehook \
          --not-when-fullscreen \
          --not-when-audio \
          --timer "$TIMEOUT" \
            'xset dpms force off; wpctl set-mute @DEFAULT_AUDIO_SINK@ 1' \
            'wpctl set-mute @DEFAULT_AUDIO_SINK@ 0' \
          &
        disown
        notify-send "Idle behaviour" "Enabled ($((TIMEOUT / 60)) min)"
      fi
    '';
  };

  home.file.".config/i3/dmenu_run.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # using dmenu-rs
      dmenu_run \
      	--font "${config.stylix.fonts.monospace.name}:size=${toString config.stylix.fonts.sizes.desktop}" \
      	--nb "${colors.base00}" \
      	--nf "${colors.base05}" \
      	--sb "${colors.base02}" \
      	--sf "${colors.base05}"
    '';
  };
}
