{ username }:

{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/home/git.nix
    ./modules/home/gh.nix
    ./modules/home/ssh.nix
    ./modules/home/zed.nix
    ./modules/home/starship.nix
    ./modules/home/zsh.nix
    ./modules/home/linux.nix
    ./modules/home/fzf.nix
  ];

  home.username = username;
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  home.packages = with pkgs; [
    awscli2
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
    notion-app
  ];

  # Enable bash for script compatibility
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # Colima autostart on macOS
  launchd.agents.colima = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [ "${pkgs.colima}/bin/colima" "start" ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/colima.out.log";
      StandardErrorPath = "/tmp/colima.err.log";
    };
  };

  home.stateVersion = "25.11";
}
