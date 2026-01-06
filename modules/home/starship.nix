{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;

    settings = {
      # Add a blank line between shell prompts
      add_newline = true;

      # Format configuration
      format = "$username$hostname$directory$git_branch$git_status$git_state$character";

      # Character configuration
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      # Directory configuration
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      # Git branch
      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = "on [$symbol$branch]($style) ";
      };

      # Git status
      git_status = {
        style = "bold red";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "🏳";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "$";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };

      # Username (only show when SSH)
      username = {
        show_always = false;
        style_user = "bold yellow";
        format = "[$user]($style) ";
      };

      # Hostname (only show when SSH)
      hostname = {
        ssh_only = true;
        style = "bold dimmed green";
        format = "on [$hostname]($style) ";
      };

      # Programming language modules
      nodejs = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
      };

      python = {
        symbol = " ";
        format = "via [\${symbol}\${pyenv_prefix}(\${version} )(\($virtualenv\) )]($style)";
      };

      rust = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state( \($name\))]($style) ";
      };
    };
  };
}
