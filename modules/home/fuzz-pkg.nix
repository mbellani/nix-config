{ lib, stdenv, fetchFromGitHub, bison, flex }:

stdenv.mkDerivation rec {
  pname = "fuzz";
  version = "2022-01-01";

  src = fetchFromGitHub {
    owner = "Spivoxity";
    repo = "fuzz";
    rev = version;
    hash = "sha256-CvVAwYOQPZiA/MlllW4WkNX8S0ztIZQ9JDLk1piGeu0=";
  };

  # zparse.y → bison, zscan.l → flex
  nativeBuildInputs = [ bison flex ];

  # src/Makefile.in hardcodes `CC=gcc`; override to use whatever the
  # stdenv provides (clang on darwin, gcc on linux).
  makeFlags = [ "CC=cc" ];

  # fuzz's Makefile calls `install` into $bindir and $libdir without
  # creating them first — pre-create so autotools install succeeds.
  preInstall = ''
    mkdir -p $out/bin $out/lib
  '';

  # The Makefile drops fuzz.sty directly under tex/latex/ — move it into
  # the conventional tex/latex/fuzz/ subdir so tools expecting that layout
  # (and the \usepackage{fuzz} lookup) find it.
  postInstall = ''
    if [ -f $out/share/texmf/tex/latex/fuzz.sty ]; then
      mkdir -p $out/share/texmf/tex/latex/fuzz
      mv $out/share/texmf/tex/latex/fuzz.sty $out/share/texmf/tex/latex/fuzz/
    fi
  '';

  meta = with lib; {
    description = "Type-checker and LaTeX style for the Z specification language";
    longDescription = ''
      The fuzz type-checker for Z, originally by J. M. Spivey. Ships the
      `fuzz` command-line tool, the `fuzz.sty` LaTeX style, and the oxsz
      Metafont sources used to render Z symbols.
    '';
    homepage = "https://github.com/Spivoxity/fuzz";
    license = licenses.bsd3; # README says "MIT-style"; source headers are BSD-3.
    platforms = platforms.unix;
    mainProgram = "fuzz";
  };
}
