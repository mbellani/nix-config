{ username }:

{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/home/git.nix
    ./modules/home/ssh.nix
    ./modules/home/zed.nix
    ./modules/home/starship.nix
    ./modules/home/zsh.nix
    ./modules/home/linux.nix
  ];

  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  home.packages = with pkgs; [
    jq
    ripgrep
    unzip
    claude-code
    claude-code-acp
    slack
  ] ++ lib.optionals stdenv.isLinux [
    _1password-gui
    google-chrome
    ghostty
  ] ++ lib.optionals stdenv.isDarwin [
    ghostty-bin
  ];

  # Enable bash for script compatibility
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  home.stateVersion = "25.11";
}
