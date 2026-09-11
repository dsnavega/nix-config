{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    usbutils
    pciutils
    ethtool
    nvme-cli
    lm_sensors
    brightnessctl
    ddcutil
    efibootmgr
    acpi
    powertop
    lsof
    nmap
    dnsutils
    whois
  ];
  hardware.i2c.enable = true;
}
