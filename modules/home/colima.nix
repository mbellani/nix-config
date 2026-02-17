{
  pkgs,
  lib,
  config,
  ...
}:

let
  yamlFormat = pkgs.formats.yaml { };

  colimaConfig = {
    cpu = 4;
    memory = 8;
    disk = 200;
    runtime = "docker";
    docker = {
      features = {
        containerd-snapshotter = false;
      };
    };
  };

  configFile = yamlFormat.generate "colima.yaml" colimaConfig;
  configDir = "${config.home.homeDirectory}/.colima/default";
  configPath = "${configDir}/colima.yaml";
in
{
  home.activation.colimaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${configDir}"
    [ -f "${configPath}" ] || { cp "${configFile}" "${configPath}" && chmod 644 "${configPath}"; }
  '';

  launchd.agents.colima = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
        "--foreground"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/colima.out.log";
      StandardErrorPath = "/tmp/colima.err.log";
    };
  };
}
