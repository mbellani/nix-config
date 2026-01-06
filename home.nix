{ config, pkgs, ... }:

{
  imports = [
    ./modules/home/git.nix
    ./modules/home/ssh.nix
    ./modules/home/zed.nix
    ./modules/home/starship.nix
    ./modules/home/zsh.nix
    ./modules/home/linux.nix
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

  # Enable bash for script compatibility
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  home.stateVersion = "25.11";
}
