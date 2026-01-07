{ config, pkgs, ... }:

{
  programs.gh = {
    enable = true;

    # Enable git credential helper to avoid permission issues, without this
    # the gh auth login won't work correctly.
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
