{ config, pkgs, ... }:

{
  # Networking
  networking.hostName = "xbow-laptop";
  networking.computerName = "xbow-laptop";

  # Nix Configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
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
  ];

  # Programs
  programs.zsh.enable = true;

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
    };
  };

  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  system.stateVersion = 6;
}
