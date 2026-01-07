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
    ];
    userSettings = {
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 15;
      icon_theme = "Catppuccin Frappé";
      indent_guides = {
        coloring = "indent_aware";
      };
      theme = {
        mode = "system";
        dark = "Catppuccin Frappé";
      };
      agent = {
        default_model = {
          provider = "anthropic";
          model = "claude-opus-4-5-20250514";
        };
      };
    };
  };
}
