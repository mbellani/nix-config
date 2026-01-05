{ config, pkgs, ... }:

{
  imports = [
    ./modules/home/git.nix
    ./modules/home/ssh.nix
    ./modules/home/zed.nix
  ];

  home.username = "mbellani";
  home.homeDirectory = "/home/mbellani";
  home.packages = with pkgs; [
    jq
    ripgrep
    unzip
    _1password-gui
    google-chrome
    claude-code
    claude-code-acp
  ];

  programs.starship = {
   enable = true;
  };

  # Must set the theme to correctly render various application icons
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  home.stateVersion = "25.11";
}
