{
  config,
  pkgs,
  lib,
  ...
}:

let
  cliTools = import ../shared/cli-tools.nix { inherit pkgs; };

  # Shared across all platforms, always installed via nix
  shared = with pkgs; [
    nixd
    nil
    nerd-fonts.hack
    slack
    terraform
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
    ++ lib.optionals pkgs.stdenv.isLinux ((map (t: t.nix) cliTools) ++ linuxApps)
    ++ lib.optionals pkgs.stdenv.isDarwin darwinApps;
}
