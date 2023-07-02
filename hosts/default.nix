{
  nixpkgs,
  inputs,
  ...
}: let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
  };

  lib = pkgs.lib.extend (self: super: {
    my = import ../lib {
      inherit inputs;

      pkgs = nixpkgs.legacyPackages.${system};
      lib = self;
    };
  });
in {
  calcium = let
    inherit (nixpkgs.lib) nixosSystem;
  in
    nixosSystem {
      inherit system;
      specialArgs = {inherit pkgs lib inputs system;};

      modules = [
        ./calcium
      ];
    };
}
