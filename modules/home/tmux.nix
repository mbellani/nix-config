{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    historyLimit = 50000;
    escapeTime = 0;
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    prefix = "C-a";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_status_modules_right "directory session"
          set -g @catppuccin_status_left_separator "█"
          set -g @catppuccin_status_right_separator "█"
          set -g @catppuccin_directory_text "#{pane_current_path}"
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    extraConfig = ''
      # True color support
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",*:Tc"

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Start panes at 1, not 0
      setw -g pane-base-index 1

      # Don't rename windows automatically
      set -g allow-rename off

      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity off

      # Better split bindings
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Create new windows in current path
      bind c new-window -c "#{pane_current_path}"

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Pane resizing with prefix + H/J/K/L
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Quick window navigation
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # Copy mode improvements (vi style)
      bind Enter copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi C-v send -X rectangle-toggle
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send -X cancel

      # Quick reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Toggle synchronize-panes
      bind S setw synchronize-panes

      # Kill pane/window shortcuts
      bind x kill-pane
      bind X kill-window
      bind q confirm-before -p "kill-session #S? (y/n)" kill-session

      # Session management
      bind N new-session
      bind s choose-tree -sZ

      # Move windows
      bind -r "<" swap-window -d -t -1
      bind -r ">" swap-window -d -t +1

      # Focus events for vim
      set -g focus-events on

      # Aggressive resize
      setw -g aggressive-resize on
    '';
  };
}
