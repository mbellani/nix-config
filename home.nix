{ config, pkgs, ... }:

{
  imports = [
    ./modules/home/git.nix
    ./modules/home/ssh.nix
    ./modules/home/zed.nix
    ./modules/home/starship.nix
    ./modules/home/zsh.nix
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
    ghostty
  ];

  # Enable bash with Starship integration
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # Must set the theme to correctly render various application icons
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  # Set Ghostty as default terminal
  dconf.settings = {
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "ghostty";
      exec-arg = "";
    };
  };

  home.stateVersion = "25.11";
}
