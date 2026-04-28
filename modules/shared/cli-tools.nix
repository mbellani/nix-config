# Single source of truth for CLI tools that are installed via Homebrew on macOS
# and via nix on Linux.
#
# Each entry: { nix = <nix package>; brew = "<homebrew formula>"; }
#
# Usage:
#   In home-manager module:  map (t: t.nix) (import ./this-file.nix { inherit pkgs; })
#   In darwin config:        map (t: t.brew) (import ./this-file.nix { inherit pkgs; })
{ pkgs }:

[
  # CLI tools
  {
    nix = pkgs.awscli2;
    brew = "awscli";
  }
  {
    nix = pkgs.btop;
    brew = "btop";
  }
  {
    nix = pkgs.jq;
    brew = "jq";
  }
  {
    nix = pkgs.k9s;
    brew = "k9s";
  }
  {
    nix = pkgs.kubectl;
    brew = "kubernetes-cli";
  }
  {
    nix = pkgs.kubernetes-helm;
    brew = "helm";
  }
  {
    nix = pkgs.lazydocker;
    brew = "lazydocker";
  }
  {
    nix = pkgs.nodejs;
    brew = "node";
  }
  {
    nix = pkgs.pnpm;
    brew = "pnpm";
  }
  {
    nix = pkgs.ripgrep;
    brew = "ripgrep";
  }
  {
    nix = pkgs.unzip;
    brew = "unzip";
  }
  {
    nix = pkgs.uv;
    brew = "uv";
  }
  {
    nix = pkgs.yq-go;
    brew = "yq";
  }

  # Haskell toolchain
  {
    nix = pkgs.ghc;
    brew = "ghc";
  }
  {
    nix = pkgs.cabal-install;
    brew = "cabal-install";
  }
  {
    nix = pkgs.stack;
    brew = "haskell-stack";
  }
  {
    nix = pkgs.haskell-language-server;
    brew = "haskell-language-server";
  }

  # LaTeX
  {
    nix = pkgs.texlive.combined.scheme-medium;
    brew = "texlive";
  }
]
