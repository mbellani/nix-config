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
    ];
    userSettings = {
      vim_mode = true;
      ui_font_size = 16;
      buffer_font_size = 15;
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Ayu Mirage";
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
