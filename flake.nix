{
  description = "Flake to manage system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{self, nixpkgs, home-manager, ...}: {
    nixosConfigurations = {
      framework = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix 
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mbellani = import ./home.nix;
          }
        ];
      };
   };
  };
}
