{
  description = "Raf's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      nixosConfigurations = {
        rotterdam = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./rotterdam/configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
