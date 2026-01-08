{ config, lib, pkgs, ... }:

{
  # Only enable on macOS
  config = lib.mkIf pkgs.stdenv.isDarwin {
    home.file.".aerospace.toml".text = ''
      # AeroSpace Configuration
      # https://github.com/nikitabobko/AeroSpace

      # Start AeroSpace at login
      start-at-login = true

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true

      # Mouse follows focus
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

      # Gaps between windows
      [gaps]
      inner.horizontal = 8
      inner.vertical = 8
      outer.left = 8
      outer.bottom = 8
      outer.top = 8
      outer.right = 8

      # Mode definitions
      [mode.main.binding]
      # All keybindings use Alt (Option) as the main modifier

      # Focus windows
      alt-h = 'focus left'
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-l = 'focus right'

      # Move windows
      alt-shift-h = 'move left'
      alt-shift-j = 'move down'
      alt-shift-k = 'move up'
      alt-shift-l = 'move right'

      # Resize mode
      alt-r = 'mode resize'

      # Workspaces
      alt-1 = 'workspace 1'
      alt-2 = 'workspace 2'
      alt-3 = 'workspace 3'
      alt-4 = 'workspace 4'
      alt-5 = 'workspace 5'
      alt-6 = 'workspace 6'
      alt-7 = 'workspace 7'
      alt-8 = 'workspace 8'
      alt-9 = 'workspace 9'

      # Move window to workspace
      alt-shift-1 = 'move-node-to-workspace 1'
      alt-shift-2 = 'move-node-to-workspace 2'
      alt-shift-3 = 'move-node-to-workspace 3'
      alt-shift-4 = 'move-node-to-workspace 4'
      alt-shift-5 = 'move-node-to-workspace 5'
      alt-shift-6 = 'move-node-to-workspace 6'
      alt-shift-7 = 'move-node-to-workspace 7'
      alt-shift-8 = 'move-node-to-workspace 8'
      alt-shift-9 = 'move-node-to-workspace 9'

      # Layout manipulation
      alt-f = 'fullscreen'
      alt-shift-s = 'layout v_accordion'
      alt-shift-w = 'layout h_accordion'
      alt-shift-t = 'layout tiles horizontal vertical'

      # Toggle floating
      alt-shift-space = 'layout floating tiling'

      # Reload config
      alt-shift-c = 'reload-config'

      # Close window
      alt-shift-q = 'close'

      # Balance windows
      alt-b = 'balance-sizes'

      [mode.resize.binding]
      h = 'resize width -50'
      j = 'resize height +50'
      k = 'resize height -50'
      l = 'resize width +50'
      enter = 'mode main'
      esc = 'mode main'

      # Workspace to monitor bindings
      [[on-window-detected]]
      if.app-id = 'com.tinyspeck.slackmacgap'
      run = 'move-node-to-workspace 9'

      [[on-window-detected]]
      if.app-id = 'com.spotify.client'
      run = 'move-node-to-workspace 8'
    '';
  };
}
