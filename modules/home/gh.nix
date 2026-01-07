{ config, pkgs, ... }:

{
  programs.gh = {
    enable = true;

    # Enable git credential helper to avoid permission issues
    gitCredentialHelper.enable = true;

    settings = {
      git_protocol = "ssh";
      prompt = "enabled";

      aliases = {
        co = "pr checkout";
        pv = "pr view";
        rv = "repo view";
        rl = "repo list";
      };
    };
  };
}
