{ pkgs, ... }:
{

  # boot and kernel parameters
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 8;
      timeout = 0;
    };
    plymouth.enable = true;
    initrd.systemd.enable = true;
    initrd.verbose = false;
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "user_namespace.enable=1"
      "i915.enable_dpcd_backlight=1"
    ];
  };

  # microcode
  hardware.enableRedistributableFirmware = true;

  # swap
  boot.initrd.luks.devices."luks-f4169635-35a5-4765-8a6b-c3bf07bc0791" = {
    device = "/dev/disk/by-uuid/f4169635-35a5-4765-8a6b-c3bf07bc0791";
    keyFile = "/etc/secrets/initrd/swap.key";
  };
  boot.initrd.secrets."/etc/secrets/initrd/swap.key" = "/etc/secrets/initrd/swap.key";

}
