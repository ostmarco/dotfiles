{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = inputs @ {nixpkgs, ...}: {
    nixosConfigurations = import ./hosts {inherit inputs nixpkgs;};
  };
}
