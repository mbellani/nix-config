{ config, lib, pkgs, ... }:

{
  # Sketchybar is only of MacOs. Don't care about it on my framework laptop
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Install sketchybar and app font
    home.packages = with pkgs; [
      sketchybar
    ];

    # Colors configuration
    home.file.".config/sketchybar/colors.sh" = {
      text = ''
        #!/usr/bin/env bash

        # Catppuccin Mocha color scheme
        export WHITE=0xffffffff
        export BAR_COLOR=0xff1e1e2e
        export ITEM_BG_COLOR=0xff313244
        export ACCENT_COLOR=0xff89b4fa
        export TEXT_COLOR=0xffcdd6f4
        export SUBTEXT_COLOR=0xffa6adc8
      '';
      executable = true;
    };

    # Icon map helper from sketchybar-app-font
    home.file.".config/sketchybar/icon_map.sh" = {
      source = "${pkgs.sketchybar-app-font}/bin/icon_map.sh";
    };

    # Sketchybar configuration
    home.file.".config/sketchybar/sketchybarrc" = {
      text = ''
        #!/usr/bin/env bash

        # Sketchybar configuration for Aerospace integration

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        # Source colors
        source "$HOME/.config/sketchybar/colors.sh"

        # Bar appearance
        $SKETCHYBAR --bar \
          height=32 \
          color=$BAR_COLOR \
          shadow=off \
          position=top \
          sticky=on \
          padding_left=10 \
          padding_right=10 \
          y_offset=0 \
          margin=0 \
          blur_radius=0

        # Default settings
        $SKETCHYBAR --default \
          updates=when_shown \
          icon.font="Hack Nerd Font:Bold:14.0" \
          icon.color=$TEXT_COLOR \
          label.font="Hack Nerd Font:Regular:14.0" \
          label.color=$TEXT_COLOR \
          padding_left=5 \
          padding_right=5 \
          label.padding_left=4 \
          label.padding_right=4 \
          icon.padding_left=4 \
          icon.padding_right=4

        # Front app - shows current application with icon
        $SKETCHYBAR --add event front_app_switched \
          --add item front_app left \
          --set front_app \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            icon.font="sketchybar-app-font:Regular:16.0" \
            icon.color=$TEXT_COLOR \
            label.color=$TEXT_COLOR \
            script="$HOME/.config/sketchybar/plugins/front_app.sh" \
          --subscribe front_app front_app_switched

        # Aerospace workspaces
        $SKETCHYBAR --add event aerospace_workspace_change

        for sid in $(${pkgs.aerospace}/bin/aerospace list-workspaces --all); do
          $SKETCHYBAR --add item space.$sid left \
            --subscribe space.$sid aerospace_workspace_change \
            --set space.$sid \
              background.color=$ITEM_BG_COLOR \
              background.corner_radius=5 \
              background.height=24 \
              background.drawing=on \
              icon.font="sketchybar-app-font:Regular:14.0" \
              label="$sid" \
              click_script="aerospace workspace $sid" \
              script="$HOME/.config/sketchybar/plugins/aerospace.sh $sid"
        done

        # Clock
        $SKETCHYBAR --add item clock right \
          --set clock \
            update_freq=10 \
            icon= \
            script="$HOME/.config/sketchybar/plugins/clock.sh" \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.padding_left=5 \
            background.padding_right=5

        # Battery
        $SKETCHYBAR --add item battery right \
          --set battery \
            update_freq=120 \
            script="$HOME/.config/sketchybar/plugins/battery.sh" \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.padding_left=5 \
            background.padding_right=5

        # Volume
        $SKETCHYBAR --add item volume right \
          --set volume \
            script="$HOME/.config/sketchybar/plugins/volume.sh" \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.padding_left=5 \
            background.padding_right=5 \
          --subscribe volume volume_change

        # Finalize
        $SKETCHYBAR --update
      '';
      executable = true;
    };

    # Aerospace workspace plugin
    home.file.".config/sketchybar/plugins/aerospace.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        # Source icon map
        source "$HOME/.config/sketchybar/icon_map.sh"

        # Colors
        ITEM_BG_COLOR=0xff313244
        ACCENT_COLOR=0xff89b4fa
        TEXT_COLOR=0xffcdd6f4

        # Get the currently focused workspace
        FOCUSED_WORKSPACE=$(${pkgs.aerospace}/bin/aerospace list-workspaces --focused)

        # Get apps in this workspace
        WORKSPACE_ID="$1"
        APPS=$(${pkgs.aerospace}/bin/aerospace list-windows --workspace "$WORKSPACE_ID" | awk -F'|' '{gsub(/^ +| +$/, "", $2); print $2}')

        # Create icon string from apps
        ICON_STRING=""
        if [ -n "$APPS" ]; then
          while IFS= read -r app; do
            __icon_map "$app"
            ICON_STRING+="$icon_result "
          done <<< "$APPS"
        fi

        if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
          $SKETCHYBAR --set $NAME \
            icon="$ICON_STRING" \
            background.color=$ACCENT_COLOR \
            label.color=0xff000000 \
            icon.color=0xff000000
        else
          $SKETCHYBAR --set $NAME \
            icon="$ICON_STRING" \
            background.color=$ITEM_BG_COLOR \
            label.color=$TEXT_COLOR \
            icon.color=$TEXT_COLOR
        fi
      '';
      executable = true;
    };

    # Clock plugin
    home.file.".config/sketchybar/plugins/clock.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        $SKETCHYBAR --set $NAME label="$(date '+%a %b %d %H:%M')"
      '';
      executable = true;
    };

    # Battery plugin
    home.file.".config/sketchybar/plugins/battery.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
        CHARGING=$(pmset -g batt | grep 'AC Power')

        if [ $PERCENTAGE = "" ]; then
          exit 0
        fi

        if [[ $CHARGING != "" ]]; then
          ICON=""
        elif [ $PERCENTAGE -gt 75 ]; then
          ICON=""
        elif [ $PERCENTAGE -gt 50 ]; then
          ICON=""
        elif [ $PERCENTAGE -gt 25 ]; then
          ICON=""
        else
          ICON=""
        fi

        $SKETCHYBAR --set $NAME icon="$ICON" label="''${PERCENTAGE}%"
      '';
      executable = true;
    };

    # Volume plugin
    home.file.".config/sketchybar/plugins/volume.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        VOLUME=$(osascript -e "output volume of (get volume settings)")

        if [[ $VOLUME -eq 0 ]]; then
          ICON=""
        elif [[ $VOLUME -lt 33 ]]; then
          ICON=""
        elif [[ $VOLUME -lt 66 ]]; then
          ICON=""
        else
          ICON=""
        fi

        $SKETCHYBAR --set $NAME icon="$ICON" label="''${VOLUME}%"
      '';
      executable = true;
    };

    # Front app plugin
    home.file.".config/sketchybar/plugins/front_app.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        # Source icon map
        source "$HOME/.config/sketchybar/icon_map.sh"

        # Get the front app name
        FRONT_APP=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

        # Get the app icon
        __icon_map "$FRONT_APP"

        $SKETCHYBAR --set $NAME icon="$icon_result" label="$FRONT_APP"
      '';
      executable = true;
    };

    # Launchd service to start sketchybar
    launchd.agents.sketchybar = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.sketchybar}/bin/sketchybar" ];
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Interactive";
        StandardOutPath = "/tmp/sketchybar.out.log";
        StandardErrorPath = "/tmp/sketchybar.err.log";
      };
    };
  };
}
