{
  pkgs,
  lib,
  ...
}:

{
  # Colima autostart on macOS with increased memory
  launchd.agents.colima = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.colima}/bin/colima"
        "start"
        "--memory"
        "8"
        "--cpu"
        "4"
        "--disk"
        "100"
      ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/colima.out.log";
      StandardErrorPath = "/tmp/colima.err.log";
    };
  };
}
