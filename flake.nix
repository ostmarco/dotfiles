{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    apple-fonts.url = "github:ostmarco/apple-fonts.nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    nixvim,
    stylix,
    apple-fonts,
    ...
  }: let
    systems = with flake-utils.lib.system; [
      aarch64-darwin
      x86_64-darwin
      x86_64-linux
    ];

    systemsFlakes = flake-utils.lib.eachSystem systems (system: let
      inherit (lib.extra) mapModulesRec';

      overlays = [
        (import overlays/electron.nix)
        (import overlays/postman.nix)
      ];

      lib = pkgs.lib.extend (self: super: {
        extra = import ./lib {
          inherit inputs;

          pkgs = nixpkgs.legacyPackages.${system};
          lib = self;
        };
      });

      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfree = true;
        config.permittedInsecurePackages = ["electron-25.9.0"];

        overlays =
          overlays
          ++ [
            (final: prev: apple-fonts.packages.${system})
          ];
      };

      mkHost = path: let
        inherit (builtins) baseNameOf;
        inherit (lib) mkDefault removeSuffix;
      in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit pkgs lib inputs system;};
          modules =
            [
              {
                nixpkgs.pkgs = pkgs;
                networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
              }

              home-manager.nixosModule
              nixvim.nixosModules.nixvim
              stylix.nixosModules.stylix

              (import path)
            ]
            ++ mapModulesRec' ./modules import;
        };
    in {
      nixosConfigurations = {
        red = mkHost ./hosts/red;
      };
    });

    system = "x86_64-linux";
  in
    systemsFlakes
    // {
      nixosConfigurations = systemsFlakes.nixosConfigurations.${system};
    };
}
