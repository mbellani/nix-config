{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Sketchybar is only of MacOs. Don't care about it on my framework laptop
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Install sketchybar and app font
    home.packages = with pkgs; [
      sketchybar
      sketchybar-app-font
    ];

    # Colors configuration
    home.file.".config/sketchybar/colors.sh" = {
      text = ''
        #!/usr/bin/env bash

        # Doom One color scheme
        export WHITE=0xffDFDFDF
        export BAR_COLOR=0xff282c34
        export ITEM_BG_COLOR=0xff3f444a
        export ACCENT_COLOR=0xff51afef
        export TEXT_COLOR=0xffbbc2cf
        export SUBTEXT_COLOR=0xff5B6268
        export RED=0xffff6c6b
        export GREEN=0xff98be65
        export YELLOW=0xffECBE7B
        export BLUE=0xff51afef
        export MAGENTA=0xffc678dd
        export CYAN=0xff46D9FF
        export ORANGE=0xffda8548
        export VIOLET=0xffa9a1e1
        export BLUE_ALPHA=0x6651afef
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
          height=34 \
          color=$BAR_COLOR \
          border_color=$ITEM_BG_COLOR \
          border_width=1 \
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
            background.color=$ACCENT_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            icon.font="sketchybar-app-font:Regular:16.0" \
            icon.color=0xff282c34 \
            label.color=0xff282c34 \
            script="$HOME/.config/sketchybar/plugins/front_app.sh" \
          --subscribe front_app front_app_switched

        # Aerospace workspaces
        $SKETCHYBAR --add event aerospace_workspace_change

        for sid in 1 2 3 4 5 6 7 8 9; do
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

        # Weather
        $SKETCHYBAR --add item weather right \
          --set weather \
            update_freq=900 \
            icon.color=$CYAN \
            script="$HOME/.config/sketchybar/plugins/weather.sh" \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.padding_left=5 \
            background.padding_right=5

        # Clock
        $SKETCHYBAR --add item clock right \
          --set clock \
            update_freq=10 \
            icon=" " \
            icon.color=$MAGENTA \
            icon.font="Hack Nerd Font:Regular:12.0" \
            icon.padding_right=0 \
            label.font="Hack Nerd Font:Bold:14.0" \
            label.color=$WHITE \
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
            icon.color=$GREEN \
            script="$HOME/.config/sketchybar/plugins/battery.sh" \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.padding_left=5 \
            background.padding_right=5

        # Wifi
        $SKETCHYBAR --add item wifi right \
          --set wifi \
            update_freq=10 \
            icon.color=$CYAN \
            script="$HOME/.config/sketchybar/plugins/wifi.sh" \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.padding_left=5 \
            background.padding_right=5

        # Tailscale
        $SKETCHYBAR --add item tailscale right \
          --set tailscale \
            update_freq=10 \
            script="$HOME/.config/sketchybar/plugins/tailscale.sh" \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.padding_left=5 \
            background.padding_right=5

        # Bracket: system status group
        $SKETCHYBAR --add bracket status battery wifi tailscale \
          --set status \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=26

        # CPU graph
        $SKETCHYBAR --add item cpu_icon right \
          --set cpu_icon \
            icon= \
            icon.color=$BLUE \
            label.drawing=off \
            padding_right=0 \
            background.drawing=off

        $SKETCHYBAR --add graph cpu_graph right 75 \
          --set cpu_graph \
            update_freq=2 \
            graph.color=$BLUE \
            graph.fill_color=$BLUE_ALPHA \
            graph.line_width=1.0 \
            label.drawing=off \
            icon.drawing=off \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.drawing=on \
            script="$HOME/.config/sketchybar/plugins/cpu.sh"

        # Volume
        $SKETCHYBAR --add item volume right \
          --set volume \
            icon.color=$VIOLET \
            script="$HOME/.config/sketchybar/plugins/volume.sh" \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=24 \
            background.padding_left=5 \
            background.padding_right=5 \
          --subscribe volume volume_change

        # Bracket: workspace group
        $SKETCHYBAR --add bracket spaces '/space\..*/' \
          --set spaces \
            background.color=$ITEM_BG_COLOR \
            background.corner_radius=5 \
            background.height=26

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

        # Doom One colors
        ITEM_BG_COLOR=0xff3f444a
        ACCENT_COLOR=0xff51afef
        TEXT_COLOR=0xffbbc2cf
        SUBTEXT_COLOR=0xff5B6268

        # Get the currently focused workspace
        FOCUSED_WORKSPACE=$(${pkgs.aerospace}/bin/aerospace list-workspaces --focused)

        # Get apps in this workspace
        WORKSPACE_ID="$1"
        APPS=$(${pkgs.aerospace}/bin/aerospace list-windows --workspace "$WORKSPACE_ID" | awk -F'|' '{gsub(/^ +| +$/, "", $2); print $2}')

        # Normalize known lowercase app names
        normalize_app_name() {
          case "$1" in
            zed) echo "Zed" ;;
            *) echo "$1" ;;
          esac
        }

        # Create icon string from apps (only unique apps)
        ICON_STRING=""
        if [ -n "$APPS" ]; then
          # Get unique app names only
          UNIQUE_APPS=$(echo "$APPS" | sort -u)
          while IFS= read -r app; do
            __icon_map "$(normalize_app_name "$app")"
            ICON_STRING+="$icon_result "
          done <<< "$UNIQUE_APPS"
        fi

        if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
          $SKETCHYBAR --set $NAME \
            icon="$ICON_STRING" \
            background.color=$ACCENT_COLOR \
            label.color=0xff282c34 \
            icon.color=0xff282c34
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

        DAY=$(date '+%a')
        DATE=$(date '+%d %b')
        TIME=$(date '+%H:%M')

        $SKETCHYBAR --set $NAME icon="$DAY $DATE" label="$TIME"
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
          ICON="󰂄"
        elif [ $PERCENTAGE -gt 75 ]; then
          ICON="󰁹"
        elif [ $PERCENTAGE -gt 50 ]; then
          ICON="󰂀"
        elif [ $PERCENTAGE -gt 25 ]; then
          ICON="󰁾"
        else
          ICON="󰁺"
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
          ICON="󰖁"
        elif [[ $VOLUME -lt 33 ]]; then
          ICON="󰕿"
        elif [[ $VOLUME -lt 66 ]]; then
          ICON="󰖀"
        else
          ICON="󰕾"
        fi

        $SKETCHYBAR --set $NAME icon="$ICON" label="''${VOLUME}%"
      '';
      executable = true;
    };

    # Wifi plugin
    home.file.".config/sketchybar/plugins/wifi.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        RSSI=$(swift -e 'import CoreWLAN; let i = CWWiFiClient.shared().interface(); print(i?.powerOn() == true ? (i?.rssiValue() ?? 0) : -999)' 2>/dev/null)

        if [ "$RSSI" = "-999" ] || [ -z "$RSSI" ]; then
          ICON="󰤭"
        elif [ "$RSSI" = "0" ]; then
          ICON="󰤭"
        elif [ "$RSSI" -gt -50 ]; then
          ICON="󰤨"
        elif [ "$RSSI" -gt -60 ]; then
          ICON="󰤥"
        elif [ "$RSSI" -gt -70 ]; then
          ICON="󰤢"
        else
          ICON="󰤟"
        fi

        $SKETCHYBAR --set $NAME icon="$ICON" label=""
      '';
      executable = true;
    };

    # Tailscale plugin
    home.file.".config/sketchybar/plugins/tailscale.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        TAILSCALE="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

        if [ ! -x "$TAILSCALE" ]; then
          $SKETCHYBAR --set $NAME icon="󰖂" label="" icon.color=0xff5B6268
          exit 0
        fi

        STATUS=$("$TAILSCALE" status 2>/dev/null)

        if [ $? -eq 0 ]; then
          $SKETCHYBAR --set $NAME icon="󰖂" label="" icon.color=0xff98be65
        else
          $SKETCHYBAR --set $NAME icon="󰖂" label="" icon.color=0xffff6c6b
        fi
      '';
      executable = true;
    };

    # CPU plugin (graph)
    home.file.".config/sketchybar/plugins/cpu.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        # Get CPU usage from top
        CPU_IDLE=$(top -l 1 -n 0 | grep "CPU usage" | awk '{print $7}' | tr -d '%')
        CPU_USED=$(echo "scale=2; (100 - $CPU_IDLE) / 100" | bc 2>/dev/null || echo "0.0")
        CPU_PCT=$(echo "scale=0; (100 - $CPU_IDLE) / 1" | bc 2>/dev/null || echo "0")

        $SKETCHYBAR --push $NAME "$CPU_USED"
        $SKETCHYBAR --set cpu_icon label="''${CPU_PCT}%"
      '';
      executable = true;
    };

    # Weather plugin
    home.file.".config/sketchybar/plugins/weather.sh" = {
      text = ''
        #!/usr/bin/env bash

        SKETCHYBAR="${pkgs.sketchybar}/bin/sketchybar"

        # Get location coordinates via macOS CoreLocation (fallback to SF)
        LAT="37.7749"
        LON="-122.4194"

        # Fetch weather from Open-Meteo (free, no API key)
        WEATHER=$(curl -s --max-time 10 "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code&temperature_unit=fahrenheit")

        if [ -z "$WEATHER" ]; then
          $SKETCHYBAR --set $NAME icon="󰅤" label="--°F"
          exit 0
        fi

        TEMP=$(echo "$WEATHER" | ${pkgs.jq}/bin/jq -r '.current.temperature_2m // empty' 2>/dev/null)
        CODE=$(echo "$WEATHER" | ${pkgs.jq}/bin/jq -r '.current.weather_code // empty' 2>/dev/null)

        if [ -z "$TEMP" ] || [ -z "$CODE" ]; then
          $SKETCHYBAR --set $NAME icon="󰅤" label="--°F"
          exit 0
        fi

        # Round temperature
        TEMP_ROUND=$(printf "%.0f" "$TEMP")

        # Map WMO weather codes to icons
        case $CODE in
          0)  ICON="󰖙" ;;   # Clear sky
          1)  ICON="󰖙" ;;   # Mainly clear
          2)  ICON="󰖕" ;;   # Partly cloudy
          3)  ICON="󰖐" ;;   # Overcast
          45|48) ICON="󰖑" ;; # Fog
          51|53|55) ICON="󰖗" ;; # Drizzle
          56|57) ICON="󰖗" ;; # Freezing drizzle
          61|63|65) ICON="󰖖" ;; # Rain
          66|67) ICON="󰖖" ;; # Freezing rain
          71|73|75) ICON="󰖘" ;; # Snow
          77) ICON="󰖘" ;;   # Snow grains
          80|81|82) ICON="󰖖" ;; # Rain showers
          85|86) ICON="󰖘" ;; # Snow showers
          95) ICON="󰖓" ;;   # Thunderstorm
          96|99) ICON="󰖓" ;; # Thunderstorm with hail
          *)  ICON="󰖙" ;;
        esac

        $SKETCHYBAR --set $NAME icon="$ICON" label="''${TEMP_ROUND}°F"
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

        # Normalize known lowercase app names for icon_map lookup
        case "$FRONT_APP" in
          zed) ICON_LOOKUP="Zed" ;;
          *) ICON_LOOKUP="$FRONT_APP" ;;
        esac

        # Get the app icon
        __icon_map "$ICON_LOOKUP"

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
