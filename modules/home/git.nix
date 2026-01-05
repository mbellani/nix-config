{ config, pkgs, ... }:

{
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
}
