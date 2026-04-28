{ username }:

{
  pkgs,
  lib,
  ...
}:

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
    ./modules/home/aerospace.nix
    ./modules/home/ghostty.nix
    ./modules/home/sketchybar.nix
    ./modules/home/jankyborders.nix
    ./modules/home/colima.nix
    ./modules/home/direnv.nix
    ./modules/home/tmux.nix
    ./modules/home/taws.nix
    ./modules/home/tsui.nix
    ./modules/home/typst.nix
    ./modules/home/raycast.nix
    ./modules/home/claude.nix
    ./modules/home/packages.nix
  ];

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  # Enable bash for script compatibility
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  home.stateVersion = "25.11";
}
