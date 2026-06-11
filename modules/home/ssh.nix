{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/id_ed25519";
        AddKeysToAgent = "yes";
      };

      "*" = {
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

  # SSH Agent
  services.ssh-agent.enable = true;
}
