{ pkgs, lib, ... }:

let
  tsui = pkgs.buildGoModule {
    pname = "tsui";
    version = "0.2.1";

    src = pkgs.fetchFromGitHub {
      owner = "neuralink";
      repo = "tsui";
      rev = "66ff849f9d5fbce4cc26b7365fcd0946ec4dab70";
      hash = "sha256-PzDC8+42zmnB3XnRISk35jj9SueimZ4kywHlVRmDaWs=";
    };

    vendorHash = "sha256-FIbkPE5KQ4w7Tc7kISQ7ZYFZAoMNGiVlFWzt8BPCf+A=";
    ldflags = [ "-X main.Version=0.2.1" ];

    buildInputs = lib.optionals pkgs.stdenv.isDarwin [
      pkgs.apple-sdk_15
    ];

    meta = {
      description = "An elegant TUI for configuring Tailscale";
      homepage = "https://github.com/neuralink/tsui";
      mainProgram = "tsui";
    };
  };
in
{
  home.packages = [ tsui ];
}
