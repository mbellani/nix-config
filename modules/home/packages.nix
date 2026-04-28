{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Shared across all platforms, always installed via nix
  shared = with pkgs; [
    nixd
    nil
    nerd-fonts.hack
    slack
    terraform
  ];

  # On Linux these are installed via nix.
  # On macOS they are installed via Homebrew (see hosts/xbow-laptop/configuration.nix).
  cliTools = with pkgs; [
    awscli2
    btop
    jq
    k9s
    kubectl
    kubernetes-helm
    lazydocker
    nodejs
    pnpm
    ripgrep
    unzip
    uv
    yq-go
  ];

  # Linux-only GUI apps
  linuxApps = with pkgs; [
    _1password-gui
    google-chrome
  ];

  # macOS-only apps (ones not managed by Homebrew)
  darwinApps = with pkgs; [
    notion-app
  ];
in
{
  home.packages =
    shared
    ++ lib.optionals pkgs.stdenv.isLinux (cliTools ++ linuxApps)
    ++ lib.optionals pkgs.stdenv.isDarwin darwinApps;
}
