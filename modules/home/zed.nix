{ config, pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "catppuccin"
      "git-firefly"
      "html"
      "nix"
      "tokyo-night"
      "catppuccin-icons"
      "toml"
      "typst"
      "docker"
      "dockerfile"
      "terraform"
    ];
    userSettings = {
      vim_mode = true;
      ui_font_size = 16;
      ui_font_family = "Hack Nerd Font";
      buffer_font_size = 15;
      buffer_font_family = "Hack Nerd Font";
      icon_theme = "Catppuccin Frappé";
      indent_guides = {
        coloring = "indent_aware";
      };
      colorize_brackets = true;
      theme = {
        mode = "system";
        dark = "Catppuccin Frappé";
        light = "Catppuccin Latte";
      };
      agent = {
        default_model = {
          provider = "anthropic";
          model = "claude-opus-4-5-20250514";
        };
      };
      autosave = "on_focus_change";
    };
  };
}
