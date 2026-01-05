{ config, pkgs, ... }:

{
  home.username = "mbellani";
  home.homeDirectory = "/home/mbellani";
  home.packages = with pkgs; [
    jq
    ripgrep
    unzip
    zed-editor
    _1password-gui
    google-chrome
  ];



  # SSH Configuration
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = [ "~/.ssh/id_ed25519" ];
        extraOptions = {
          AddKeysToAgent = "yes";
        };
      };
     
      "*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
          # Standard security defaults
          HashKnownHosts = "yes";
          # Reuse connections for speed
          ControlMaster = "auto";
          ControlPath = "~/.ssh/control-%r@%h:%p";
          ControlPersist = "10m";
        };
      };
    };
  };

  # SSH Agent
  services.ssh-agent.enable = true;

  # Git Configuration 
  programs.git = {
    enable = true;
    
    settings = {
      user.name = "Manish Bellani";
      user.email = "manish.bellani@gmail.com";
      init.defaultBranch = "main";
      # Always use SSH for GitHub
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };
  };

  programs.starship = {
   enable = true;
  };
 
  # Must set the theme to correctly render various application icons 
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  home.stateVersion = "25.11";
}
