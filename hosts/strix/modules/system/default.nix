{ config, pkgs, ... }:

{

  networking.hostName = "strix";

  console = {
    keyMap = "es";
    font = "ter-132n";
    packages = [ pkgs.terminus_font ];
  };

  services.logind = {
    settings = {
      Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchDocked = "ignore";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
  };

  services.thermald.enable = true;
  services.acpid.enable = true;
  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  environment.systemPackages = with pkgs; [
    btop
    nvtopPackages.nvidia
    asusctl
  ];

  services.xserver = {
    enable = true;
    dpi = 144;
    xkb = {
      layout = "es";
    };
    updateDbusEnvironment = true;
    videoDrivers = [ "nvidia" ];
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
      package = config.boot.kernelPackages.nvidiaPackages.latest;
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

  services.asusd = {
    enable = true;
    asusdConfig.text = ''
      (
          charge_control_end_threshold: 60,
          base_charge_control_end_threshold: 0,
          disable_nvidia_powerd_on_battery: true,
          ac_command: "",
          bat_command: "",
          platform_profile_linked_epp: true,
          platform_profile_on_battery: Quiet,
          change_platform_profile_on_battery: true,
          platform_profile_on_ac: Balanced,
          change_platform_profile_on_ac: true,
          profile_quiet_epp: Power,
          profile_balanced_epp: BalancePower,
          profile_custom_epp: Performance,
          profile_performance_epp: Performance,
          ac_profile_tunings: {
              Quiet: (enabled: false, group: {}),
              Balanced: (enabled: false, group: {}),
              Performance: (enabled: false, group: {}),
          },
          dc_profile_tunings: {
              Quiet: (enabled: false, group: { NvTempTarget: 75, NvDynamicBoost: 0 }),
          },
          armoury_settings: { MiniLedMode: 0, PanelOverdrive: 0 },
      )
    '';
    auraConfigs."19b6".text = ''
      (
          config_name: "aura_19b6.ron",
          brightness: Med,
          current_mode: Static,
          builtins: {
              Static: (mode: Static, zone: r#None, colour1: (r: 255, g: 255, b: 255), colour2: (r: 0, g: 0, b: 0), speed: Med, direction: Right),
          },
          multizone_on: false,
          enabled: (
              states: [
                  (zone: Keyboard, boot: true, awake: true, sleep: true, shutdown: true),
                  (zone: Lightbar, boot: false, awake: false, sleep: false, shutdown: false),
                  (zone: Logo, boot: false, awake: false, sleep: false, shutdown: false),
                  (zone: RearGlow, boot: false, awake: false, sleep: false, shutdown: false),
              ],
          ),
      )
    '';
  };
}
