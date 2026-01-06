{
  description = "Multi-platform Nix configuration for NixOS and macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{self, nixpkgs, nixpkgs-unstable, darwin, home-manager, home-manager-unstable, ...}: {
    # NixOS Configurations
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/framework/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mbellani = import ./home.nix { username = "mbellani"; };
          }
        ];
      };
    };

    # nix-darwin Configurations
    darwinConfigurations = {
      xbow-laptop = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/xbow-laptop/configuration.nix
          home-manager-unstable.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."manish.bellani" = import ./home.nix { username = "manish.bellani"; };
          }
        ];
      };
    };
  };
}
