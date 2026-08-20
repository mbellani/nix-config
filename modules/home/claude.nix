{ pkgs, ... }:

{
  programs.claude-code = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then null else pkgs.claude-code;

    context = ./agents/global-instructions.md;

    settings = {
      permissions.allow = [
        "Bash(find *)"
        "Bash(grep *)"
        "Bash(rg *)"
      ];
      model = "opus[1m]";
      effortLevel = "high";
      tui = "fullscreen";
      skipWorkflowUsageWarning = true;
      skipAutoPermissionPrompt = true;
    };

    skills = {
      grill-me = ./agents/skills/grill-me;
      fetch-granola-notes = ./claude/skills/fetch-granola-notes;
    };
  };
}
