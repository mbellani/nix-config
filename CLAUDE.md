# nix-config

Multi-platform Nix configuration for macOS (xbow-laptop) and NixOS (framework).

## Build commands

```bash
# macOS
darwin-rebuild switch --flake .#xbow-laptop

# NixOS
nixos-rebuild switch --flake .#framework
```

## Repo structure

- `flake.nix` — entry point, defines inputs and per-host outputs
- `home.nix` — shared home-manager config, imports all modules from `./modules/home/`
- `hosts/<hostname>/configuration.nix` — system-level config per host
- `modules/home/<tool>.nix` — one file per tool/program

## Conventions

- Home-manager modules use the standard `{ config, pkgs, lib, ... }: { ... }` pattern
- Add platform guards for platform-specific packages and config
- Platform guards: `lib.mkIf pkgs.stdenv.isDarwin { ... }` / `stdenv.isLinux`
- Prefer home-manager program modules (e.g. `programs.git`, `programs.zed-editor`) over `home.file` or `xdg.configFile`. Use raw files only when no home-manager module exists.
- Put tool configuration in its own `modules/home/<tool>.nix`, not inline in `home.nix`
- Check that nix packages aren't marked broken before adding. On macOS, fall back to Homebrew casks when a nix package is broken.
- Always `git add` newly created module files before running `darwin-rebuild switch`
- 2-space indentation in nix files

## Workflow

When the user changes a tool's settings at runtime (e.g. Zed, Ghostty, Aerospace), the goal is usually to persist those changes back into the corresponding `modules/home/<tool>.nix` file. Compare the runtime config with the nix module and update the nix module to match.

## Hosts / usernames

| Host | Platform | Username |
|------|----------|----------|
| xbow-laptop | aarch64-darwin | manish.bellani |
| framework | x86_64-linux | mbellani |
