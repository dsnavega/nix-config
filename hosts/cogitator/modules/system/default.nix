{ config, pkgs, ... }:
{

  system.stateVersion = "26.05";
  networking.hostName = "cogitator";

  console = {
    keyMap = "pt-latin1";
    font = "ter-132n";
    packages = [ pkgs.terminus_font ];
  };

  services = {
    thermald.enable = true;
    acpid.enable = true;
    fwupd.enable = true;
    xserver = {
      enable = false;
      updateDbusEnvironment = false;
      videoDrivers = [ "nvidia" ];
      xkb = {
        layout = "pt";
      };
      dpi = null;
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
      open = false;
      modesetting.enable = true;
      nvidiaSettings = false;
    };
    nvidia-container-toolkit.enable = true;
  };

  environment.systemPackages = with pkgs; [
    htop
    btop
    nvtopPackages.nvidia
  ];

}
