{ config, lib, pkgs, ... }:

{
  # Only enable on macOS
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Use the official home-manager jankyborders service
    services.jankyborders = {
      enable = true;
      settings = {
        style = "round";
        width = 5.0;
        hidpi = "off";
        active_color = "0xffe1e3e4";
        inactive_color = "0xff494d64";
      };
    };
  };
}
