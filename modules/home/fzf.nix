{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    fd
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Use fd for faster file searching
    defaultCommand = "fd --type f --hidden --follow --exclude .git";

    # CTRL-T: paste selected files/directories onto command line
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];

    # ALT-C: cd into selected directory
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'ls -la {}'"
    ];

    # CTRL-R: search command history
    historyWidgetOptions = [
      "--sort"
      "--exact"
    ];
  };
}
