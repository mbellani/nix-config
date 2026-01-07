{ config, pkgs, lib, ... }:

{
  # Linux-specific home-manager configuration
  config = lib.mkIf pkgs.stdenv.isLinux {
    # GTK theme configuration
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    # Set Ghostty as default terminal
    dconf.settings = {
      "org/gnome/desktop/default-applications/terminal" = {
        exec = "ghostty";
        exec-arg = "";
      };

      "org/gnome/SessionManager" = {
        auto-save-session = true;
      };

      "org/gnome/gnome-session" = {
        auto-save-session = true;
      };
    };
  };
}
