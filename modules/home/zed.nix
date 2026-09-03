{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Extensions Zed should have installed. On Linux these are managed declaratively
  # by the home-manager module; on macOS Zed auto-installs them from settings.json
  # (see auto_install_extensions below) since the app comes from Homebrew.
  extensions = [
    "basher"
    "catppuccin"
    "git-firefly"
    "html"
    "nix"
    "nvim-nightfox"
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

  # Shared Zed settings, fed to programs.zed-editor.userSettings on Linux and
  # written to settings.json directly on macOS.
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
      codex-acp.type = "registry";
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
      dark = "Terafox - opaque";
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
in
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

  # Linux: Zed from nixpkgs (cached, prebuilt) via the home-manager module.
  programs.zed-editor = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    inherit extensions userSettings;
  };

  # macOS: Zed comes from Homebrew (see hosts/xbow-laptop/configuration.nix) because
  # the nixpkgs darwin build compiles from source (~40 min, apple-sdk not cached).
  # Write settings.json ourselves and let Zed auto-install extensions on launch.
  xdg.configFile."zed/settings.json" = lib.mkIf pkgs.stdenv.isDarwin {
    text = builtins.toJSON (userSettings // {
      auto_install_extensions = lib.genAttrs extensions (_: true);
    });
  };

  # macOS: symlink the Zed CLI so `zed .` works from the terminal. The CLI must
  # come from the same Zed.app that is running, else it hangs on a missing socket.
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    ".local/bin/zed".source =
      config.lib.file.mkOutOfStoreSymlink "/Applications/Zed.app/Contents/MacOS/cli";
  };
}
