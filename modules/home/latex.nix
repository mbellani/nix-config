{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.texlive.combined.scheme-medium
  ];
}
