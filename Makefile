# Detect host and set appropriate rebuild command
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
  HOSTNAME ?= xbow-laptop
  REBUILD_CMD = sudo darwin-rebuild switch --flake .#$(HOSTNAME)
else
  HOSTNAME ?= framework
  REBUILD_CMD = sudo nixos-rebuild switch --flake .#$(HOSTNAME)
endif

.PHONY: switch update update-input upgrade build check fmt gc gc-old add-all diff

## Build and switch to the current configuration
switch:
	$(REBUILD_CMD)

## Update flake.lock to latest package versions
update:
	nix flake update

## Update a single flake input (usage: make update-input INPUT=nixpkgs-unstable)
update-input:
ifndef INPUT
	$(error INPUT is required. Usage: make update-input INPUT=nixpkgs-unstable)
endif
	nix flake update $(INPUT)

## Update flake.lock and rebuild (full upgrade)
upgrade: update switch

## Build without switching (dry run)
build:
ifeq ($(UNAME), Darwin)
	darwin-rebuild build --flake .#$(HOSTNAME)
else
	nixos-rebuild build --flake .#$(HOSTNAME)
endif

## Check flake for errors
check:
	nix flake check

## Format all nix files
fmt:
	nix fmt

## Garbage collect old generations (older than 7 days)
gc:
	sudo nix-collect-garbage --delete-older-than 7d

## Garbage collect ALL old generations
gc-all:
	sudo nix-collect-garbage -d

## Git add all new files (required before rebuild for new modules)
add-all:
	git add -A

## Show what changed since last generation
diff:
	nix store diff-closures /nix/var/nix/profiles/system $$(ls -d /nix/var/nix/profiles/system-*-link | sort -V | tail -1) 2>/dev/null || echo "No previous generation to diff against"

## Show current flake inputs and their revisions
inputs:
	nix flake metadata

## List all generations
generations:
ifeq ($(UNAME), Darwin)
	darwin-rebuild --list-generations 2>/dev/null || sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
else
	sudo nixos-rebuild list-generations
endif

## Help
help:
	@echo "nix-config Makefile"
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@grep -E '^## ' Makefile | sed 's/^## //'  | paste - - | awk -F'\t' '{printf "  %-20s %s\n", $$2, $$1}' || true
	@echo ""
	@echo "  switch              Build and switch to the current configuration"
	@echo "  update              Update flake.lock to latest package versions"
	@echo "  update-input        Update a single flake input (INPUT=nixpkgs-unstable)"
	@echo "  upgrade             Update flake.lock and rebuild (full upgrade)"
	@echo "  build               Build without switching (dry run)"
	@echo "  check               Check flake for errors"
	@echo "  fmt                 Format all nix files"
	@echo "  gc                  Garbage collect generations older than 7 days"
	@echo "  gc-all              Garbage collect ALL old generations"
	@echo "  add-all             Git add all new files"
	@echo "  diff                Show what changed since last generation"
	@echo "  inputs              Show current flake inputs and their revisions"
	@echo "  generations         List all generations"
	@echo "  help                Show this help"

.DEFAULT_GOAL := help
