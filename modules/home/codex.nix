{ pkgs, ... }:

{
  programs.codex = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then null else pkgs.codex;

    context = ./agents/global-instructions.md;
  };

  # Codex and other agents load personal skills from ~/.agents/skills.
  home.file = {
    ".agents/skills/grill-me/SKILL.md".source = ./agents/skills/grill-me/SKILL.md;
    ".agents/skills/fetch-granola-notes/SKILL.md".source =
      ./claude/skills/fetch-granola-notes/SKILL.md;
  };
}
