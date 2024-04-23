{...}: {
  sound.enable = false;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };

    jack.enable = false;
    pulse.enable = true;
  };
}
