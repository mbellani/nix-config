{ pkgs, ... }:

let
  taws = pkgs.rustPlatform.buildRustPackage rec {
    pname = "taws";
    version = "1.3.0-rc.7";

    src = pkgs.fetchFromGitHub {
      owner = "huseyinbabal";
      repo = "taws";
      rev = "v${version}";
      hash = "sha256-oxahcQp14ooQ8pIOcaaf0IQRkuASl4grLulGKUKSKcw=";
    };

    cargoHash = "sha256-7zZ2JJVQem2R072sefv2oB9mmQcRuUHVKKcb+HEnm6Y=";

    meta = with pkgs.lib; {
      description = "Terminal UI for AWS";
      homepage = "https://github.com/huseyinbabal/taws";
      license = licenses.mit;
      mainProgram = "taws";
    };
  };
in
{
  home.packages = [ taws ];
}
