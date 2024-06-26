# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  inputs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [];

  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c6eaa438-a841-467e-a5f7-236ddff5657d";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-07532e89-42ab-476d-ba1a-af7b5d52d0bd".device = "/dev/disk/by-uuid/07532e89-42ab-476d-ba1a-af7b5d52d0bd";
  boot.initrd.luks.devices."luks-a828ece0-f4a6-4401-bdf5-578e611291bd".device = "/dev/disk/by-uuid/a828ece0-f4a6-4401-bdf5-578e611291bd";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6E82-F2C2";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/5a2d2839-23a8-4a1b-8219-1e62faf011b5";}
  ];

  powerManagement.cpuFreqGovernor = "performance";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp44s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp43s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
}
