{ config, pkgs, ... }:

{
  home.file.".gitconfig.xbow".text = ''
    [user]
      email = manish.bellani@xbow.com
  '';

  home.packages = [ pkgs.delta ];

  programs.git = {
    enable = true;

    settings = {
      user.name = "Manish Bellani";
      user.email = "manish.bellani@gmail.com";
      init.defaultBranch = "main";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        dark = true;
        side-by-side = false;
        line-numbers = true;
        syntax-theme = "OneHalfDark";
        navigate = true;
      };
      # Always use SSH for GitHub
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
    };

    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:xbow-engineering/**";
        path = "~/.gitconfig.xbow";
      }
      {
        condition = "hasconfig:remote.*.url:https://github.com/xbow-engineering/**";
        path = "~/.gitconfig.xbow";
      }
      {
        condition = "gitdir:~/src/github.com/xbow-engineering/";
        path = "~/.gitconfig.xbow";
      }
    ];
  };
}
