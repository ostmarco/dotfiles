{
  inputs,
  pkgs,
  ...
}: let
  mkCache = url: key: {inherit url key;};

  caches = let
    irancho = mkCache "http://nix-cache.irancho.com.br" "nix-cache.irancho.com.br:HvCdS6lKTt7MTMnBLfcGAVqmroQiEV1j36tbNr0YM98=";
    nixos = mkCache "https://cache.nixos.org" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    cachix = mkCache "https://cachix.cachix.org" "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  in [irancho nixos cachix];

  cachesUrls = map (cache: cache.url) caches;
  cachesKeys = map (cache: cache.key) caches;
in {
  config = {
    nix = {
      package = pkgs.nixVersions.latest;

      settings = {
        substituters = cachesUrls;
        trusted-substituters = cachesUrls;
        trusted-public-keys = cachesKeys;

        max-jobs = "auto";
        auto-optimise-store = true;
        experimental-features = "nix-command flakes";
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--max-freed 1G --delete-older-than 7d";
      };
    };

    system = {
      stateVersion = "24.05";
      autoUpgrade = {
        enable = true;
        flake = inputs.self.outPath;
        flags = ["--update-input" "nixpkgs" "-L"];
        dates = "02:00";
        randomizedDelaySec = "45min";
      };
    };
  };
}
