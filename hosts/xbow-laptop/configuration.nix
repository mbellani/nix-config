{ config, pkgs, ... }:

{
  # Networking
  networking.hostName = "xbow-laptop";
  networking.computerName = "xbow-laptop";

  # Nix Configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 2; Minute = 0; };
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
    casks = [
      "nikitabobko/tap/aerospace"
    ];
  };

  # Security - Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS-specific settings
  system.defaults = {
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
