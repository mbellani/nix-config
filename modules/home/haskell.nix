{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = lib.optionals pkgs.stdenv.isLinux (
    with pkgs;
    [
      ghc
      cabal-install
      stack
      haskell-language-server
    ]
  );
}
