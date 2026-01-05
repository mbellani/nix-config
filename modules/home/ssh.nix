{ config, pkgs, ... }:

{
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
}
