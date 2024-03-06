final: prev: {
  postman = prev.postman.overrideAttrs (old: let
    version = "20230716100528";
  in {
    inherit version;

    src = final.fetchurl {
      url = "https://web.archive.org/web/${version}/https://dl.pstmn.io/download/latest/linux_64";
      sha256 = "sha256-svk60K4pZh0qRdx9+5OUTu0xgGXMhqvQTGTcmqBOMq8=";

      name = "${old.pname}-${version}.tar.gz";
    };
  });
}
