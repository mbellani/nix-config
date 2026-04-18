{ config, pkgs, ... }:

let
  fuzz = pkgs.callPackage ./fuzz.nix { };
in
{
  home.packages = [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium        # core LaTeX + engines + common packages
        newcomputermodern    # refreshed Computer Modern — nicer glyphs than lmodern
        latexmk              # convenient build driver
        stmaryrd             # extra math symbols often needed for formal methods
        enumitem             # custom enumerate labels (bold (a), (b), ...)
        titlesec             # section/subsection styling (numbered "1.a)" labels)
        tcolorbox            # framed/coloured boxes (note blocks, callouts)
        ;
    })
    fuzz
  ];

  # Expose fuzz's LaTeX style + Metafont sources to kpathsea via the
  # user texmf tree. kpathsea auto-searches ~/texmf (TEXMFHOME) by default.
  home.file = {
    "texmf/tex/latex/fuzz/fuzz.sty".source =
      "${fuzz}/share/texmf/tex/latex/fuzz/fuzz.sty";
    "texmf/fonts/source/public/oxsz".source =
      "${fuzz}/share/texmf/fonts/source/public/oxsz";
  };
}
