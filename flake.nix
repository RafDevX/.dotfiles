{
  description = "Raf's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { nixpkgs, ... }: {
    nixosConfigurations = {
        rotterdam = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./rotterdam/configuration.nix
             ];
        };
    };
  };
}
