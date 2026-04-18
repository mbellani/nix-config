{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Claude Code user-global skills
  # Source files live in ./claude/skills/<skill-name>/ and are symlinked into
  # ~/.claude/skills/ by home-manager. Skills are declarative: edit the source
  # here and re-run darwin-rebuild (or home-manager switch) to update.
  home.file.".claude/skills/fetch-granola-notes/SKILL.md".source =
    ./claude/skills/fetch-granola-notes/SKILL.md;
}
