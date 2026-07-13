{ config, pkgs, ... }:

let
  cliTools = import ../../modules/shared/cli-tools.nix { inherit pkgs; };
in
{
  # Networking
  networking.hostName = "xbow-laptop";
  networking.computerName = "xbow-laptop";

  # Nix Configuration
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
  nix.settings.extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 2;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };

  # System Configuration
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    colima
    docker
    docker-compose
    amazon-ecr-credential-helper
    visualvm
    jdk
  ];

  # User Configuration
  users.users."manish.bellani" = {
    home = "/Users/manish.bellani";
    shell = pkgs.zsh;
  };

  # Programs
  programs.zsh.enable = true;

  # Homebrew
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "uninstall"; # remove formulae not listed here
      # Homebrew (2026-05-24+) refuses non-interactive `brew bundle --cleanup`
      # without an explicit force flag. nix-darwin emits bare `--cleanup`, so
      # append --force-cleanup here to keep activation non-interactive.
      # NOTE: --cleanup now also uninstalls Mac App Store apps absent from the
      # Brewfile; forcing it skips Homebrew's new confirmation prompt.
      extraFlags = [ "--force-cleanup" ];
    };
    taps = [ "felixkratz/formulae" ];
    # sketchybar via Homebrew: nixpkgs-unstable build crashes cctools ld.
    brews = [ "felixkratz/formulae/sketchybar" ] ++ map (t: t.brew) cliTools;
    casks = [
      "nikitabobko/tap/aerospace"
      "agentsview"
      "claude-code"
      "codex"
      "granola"
      "intellij-idea-ce"
      "ollama-app"
      "session-manager-plugin"
      "zed"
    ];
  };

  # Security - Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS-specific settings
  system.defaults = {
    # Disable Spotlight Cmd+Space so Raycast can use it
    CustomSystemPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "64" = {
            enabled = false;
            value = {
              parameters = [
                32
                49
                1048576
              ];
              type = "standard";
            };
          };
        };
      };
    };
    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      QuitMenuItem = true;
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      KeyRepeat = 2;
      _HIHideMenuBar = true;
    };
  };

  # Primary user for system defaults
  system.primaryUser = "manish.bellani";

  system.stateVersion = 6;
}
