{pkgs, ...}: let
  mkCache = url: key: {inherit url key;};

  caches = let
    nixos = mkCache "https://cache.nixos.org" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    cachix = mkCache "https://cachix.cachix.org" "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM=";
  in [nixos cachix];

  cachesUrls = map (cache: cache.url) caches;
  cachesKeys = map (cache: cache.key) caches;
in {
  config = {
    nix = {
      package = pkgs.nixUnstable;

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

    system.stateVersion = "23.11";
  };
}
