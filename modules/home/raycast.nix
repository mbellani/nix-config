{
  pkgs,
  lib,
  ...
}:

lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = [ pkgs.raycast ];

  targets.darwin.defaults = {
    # Set Raycast hotkey to Cmd+Space
    "com.raycast.macos".raycastGlobalHotkey = "Command-49";
  };
}
