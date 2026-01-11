{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      font-family = "Hack Nerd Font";

      font-size = 14;
      window-padding-x = 2;
      window-padding-y = 2;

      # Transparency settings
      background-opacity = 0.9;
      background-blur = 20;
    };
  };
}
