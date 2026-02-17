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
  ];

  home.username = username;
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";

  home.packages =
    with pkgs;
    [
      awscli2
      jq
      yq-go
      ripgrep
      terraform
      unzip
      claude-code
      claude-code-acp
      slack
      nerd-fonts.hack
      btop
      lazydocker
      nixd
      nil
      nodejs
      nodePackages.pnpm
      kubectl
      k9s
      jetbrains.idea
      kubernetes-helm
    ]
    ++ lib.optionals stdenv.isLinux [
      _1password-gui
      google-chrome
    ]
    ++ lib.optionals stdenv.isDarwin [
      notion-app
    ];

  # Enable bash for script compatibility
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  home.stateVersion = "25.11";
}
