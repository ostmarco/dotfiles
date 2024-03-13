final: prev: {
  postman = prev.postman.overrideAttrs (old: {
    src = final.fetchurl {
      url = "https://dl.pstmn.io/download/latest/linux_64";
      sha256 = "sha256-NH5bfz74/WIXbNdYs6Hoh/FF54v2+b4Ci5T7Y095Akw=";

      name = "${old.pname}-latest.tar.gz";
    };
  });
}
