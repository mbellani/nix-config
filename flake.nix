{
  description = "Multi-platform Nix configuration for NixOS and macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{self, nixpkgs, nixpkgs-darwin, darwin, home-manager, ...}: {
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
            home-manager.users.mbellani = import ./home.nix;
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
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."manish.bellani" = import ./home.nix;
          }
        ];
      };
    };
  };
}
