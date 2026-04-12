{
  config,
  pkgs,
  lib,
  ...
}:

{
  xdg.configFile."zed/tasks.json".text = builtins.toJSON [
    {
      label = "gh-dash";
      command = "gh";
      args = [ "dash" ];
      reveal = "always";
      reveal_target = "center";
      hide = "never";
    }
  ];

  # Create a symlink for Zed CLI on macOS so that `zed .` works from the terminal.
  # The CLI must come from the same Zed.app bundle that is running, otherwise it hangs
  # waiting for a socket that doesn't exist.
  home.file = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.isDarwin {
      ".local/bin/zed".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Applications/Home Manager Apps/Zed.app/Contents/MacOS/cli";
    })
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "basher"
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
      "kotlin"
      "latex"
      "haskell"
    ];
    userSettings = {
      load_direnv = "direct";
      lsp = {
        kotlin-lsp = {
          initialization_options = {
            java = {
              home = "${pkgs.jdk}";
            };
          };
          settings = {
            compiler = {
              jvm = {
                target = "21";
              };
            };
          };
        };
      };
      languages = {
        Kotlin = {
          language_servers = [ "kotlin-lsp" ];
          format_on_save = "off";
        };
      };
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
        dark = "Catppuccin Mocha";
        light = "Catppuccin Latte";
      };
      language_models = {
        ollama = {
          api_url = "http://localhost:11434";
          available_models = [
            {
              name = "gemma4:31b";
              display_name = "Gemma 4 31B";
              max_tokens = 131072;
              keep_alive = "30m";
            }
          ];
        };
      };
      agent = {
        default_model = {
          provider = "anthropic";
          model = "claude-opus-4-5-20250514";
        };
        favorite_models = [
          {
            provider = "ollama";
            model = "gemma4:31b";
          }
        ];
      };
      autosave = "on_focus_change";
      edit_predictions = {
        mode = "subtle";
      };
    };
  };
}
