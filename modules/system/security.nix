{
  security.rtkit.enable = true;

  security.pam.services.swaylock = {};
  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];
}
