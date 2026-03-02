{ pkgs, ... }:

{
  home.packages = with pkgs; [
    typst
  ];

  # Typst configuration
  xdg.configFile."typst/typstfmt.toml".text = ''
    max_line_length = 100
    indent_space = 2
  '';
}
