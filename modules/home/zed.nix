{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Create a symlink for Zed CLI on macOS so that `zed .` works from the terminal.
  # The CLI must come from the same Zed.app bundle that is running, otherwise it hangs
  # waiting for a socket that doesn't exist.
  home.file = lib.mkMerge [
    (lib.mkIf pkgs.stdenv.isDarwin {
      ".local/bin/zed".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Applications/Home Manager Apps/Zed.app/Contents/MacOS/cli";
    })
    {
      ".local/bin/kotlin-lsp-wrapper" = {
        source = pkgs.writeShellScript "kotlin-lsp-wrapper" ''
          export JAVA_TOOL_OPTIONS="-Xmx8g"
          exec ${pkgs.kotlin-language-server}/bin/kotlin-language-server "$@"
        '';
      };
    }
  ];

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
      "kotlin"
    ];
    userSettings = {
      load_direnv = "direct";
      languages = {
        Kotlin = {
          language_servers = [ "kotlin-language-server" ];
        };
      };
      lsp = {
        kotlin-language-server = {
          binary = {
            path = "${config.home.homeDirectory}/.local/bin/kotlin-lsp-wrapper";
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
