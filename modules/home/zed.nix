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
      "erlang"
      "terraform"
      "kotlin"
      "latex"
      "haskell"
      "claude-code-inspired-dark"
      "direnv"
      "kubernetes-helm"
    ];
    userSettings = {
      load_direnv = "direct";
      cli_default_open_behavior = "existing_window";
      project_panel.dock = "left";
      outline_panel.dock = "left";
      collaboration_panel.dock = "left";
      git_panel.dock = "left";
      terminal = {
        copy_on_select = false;
        option_as_meta = false;
      };
      agent_servers = {
        pi-acp.type = "registry";
        claude-acp = {
          type = "registry";
          favorite_models = [ "opus" ];
        };
      };
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
          binary.env.JAVA_TOOL_OPTIONS = "-Xmx16g";
        };
      };
      languages = {
        Kotlin = {
          language_servers = [ "kotlin-lsp" ];
          format_on_save = "off";
        };
        # Use elp (erlang-language-platform) from the project devShell/direnv PATH.
        # erlang-ls is archived upstream; "!erlang-ls" disables its dead auto-download.
        Erlang = {
          language_servers = [ "elp" "!erlang-ls" ];
        };
      };
      vim_mode = true;
      ui_font_size = 16;
      ui_font_family = "Hack Nerd Font";
      buffer_font_size = 15;
      buffer_font_family = "Hack Nerd Font";
      icon_theme = {
        mode = "light";
        light = "Catppuccin Frappé";
        dark = "Catppuccin Frappé";
      };
      indent_guides = {
        coloring = "indent_aware";
      };
      colorize_brackets = true;
      theme = {
        mode = "dark";
        dark = "Claude Code Inspired Dark";
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
        dock = "right";
        default_model = {
          provider = "anthropic";
          model = "claude-opus-4-8";
          effort = "high";
          enable_thinking = true;
        };
        favorite_models = [
          {
            provider = "ollama";
            model = "gemma4:31b";
          }
        ];
        model_parameters = [ ];
        tool_permissions = {
          tools = {
            terminal = {
              always_allow = [
                { pattern = "^mv\\s"; }
                { pattern = "^nix\\s+develop(\\s|$)"; }
                { pattern = "^ls\\s+packages/server/\\.env\\*(\\s|$)"; }
                { pattern = "^ls\\s+\\.env\\*(\\s|$)"; }
              ];
            };
          };
        };
      };
      autosave = "on_focus_change";
      edit_predictions = {
        mode = "subtle";
      };
    };
  };
}
