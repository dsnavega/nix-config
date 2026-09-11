{
  config,
  lib,
  pkgs,
  ...
}:

{

  networking.hostName = "zenbook";

  console.keyMap = "pt-latin1";

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
  };

  services.undervolt = {
    enable = true;
    coreOffset = -100;
    gpuOffset = -50;
    uncoreOffset = -50;
    useTimer = true;
  };

  services.acpid.enable = true;
  services.thermald.enable = true;
  services.fwupd.enable = true;

  # kmscon: nicer console font than the default vgacon
  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    config = {
      hwaccel = false;
      "font-size" = lib.mkForce 18;
    };
  };
  stylix.targets.kmscon.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    nvtopPackages.nvidia
  ];

  services.xserver = {
    enable = true;
    xkb.layout = "pt";
    updateDbusEnvironment = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.enableRedistributableFirmware = true;

}
