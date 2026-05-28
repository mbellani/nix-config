{ pkgs, lib, ... }:

let
  fuzz = pkgs.callPackage ./fuzz-pkg.nix { };
in
{
  home.packages = [ fuzz ];

  # Symlink fuzz.sty + Metafont sources (oxsz) into TEXMFHOME (~/texmf)
  # so brew-installed TeX Live finds everything via \usepackage{fuzz}.
  home.file."texmf/tex/latex/fuzz/fuzz.sty".source =
    "${fuzz}/share/texmf/tex/latex/fuzz/fuzz.sty";

  home.file."texmf/fonts/source/public/oxsz" = {
    source = "${fuzz}/share/texmf/fonts/source/public/oxsz";
    recursive = true;
  };
}
