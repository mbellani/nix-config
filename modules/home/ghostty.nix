{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      macos-titlebar-style = hidden;
      font-family = "FiraCode Nerd Font";
      font-size = 14;
      theme = "dark";
      window-padding-x = 2;
      window-padding-y = 2;
    };
  };
}
