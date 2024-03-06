final: prev: {
  discord = prev.discord.overrideAttrs (_: {
    src = builtins.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/0.0.43/discord-0.0.43.tar.gz";
      sha256 = "1sfyimq80bhnwf1qcmjhxhyqhmy5z0f6c2dbbd5ahj3fk55ipvqc";
    };
  });
}
