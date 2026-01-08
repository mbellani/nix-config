{ config, pkgs, ... }:

{
  programs.awscli = {
    enable = true;
    package = pkgs.awscli2;

    settings = {
      default = {
        region = "us-east-1";
        output = "json";
      };
    };
}
