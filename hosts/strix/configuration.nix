{ pkgs, ... }:

{

  # imports
  imports = [
    # host-specific
    ../strix/modules/boot
    ../strix/modules/system
    ../strix/modules/stylix
    # nix settings
    ../../modules/core/nix
    # packages
    ../../modules/core/packages/hardware
    ../../modules/core/packages/cli
    # system-wide
    ../../modules/core/environment
    ../../modules/core/system
    ../../modules/core/security
    ../../modules/core/network
    ../../modules/core/network/wifi-share.nix
    ../../modules/core/virtualisation
    ../../modules/core/locale
    ../../modules/core/fonts
    ../../modules/core/development
    ../../modules/core/artificial-intelligence
    ../../modules/desktop/services
    ../../modules/desktop/window-manager/i3
    ../../modules/desktop/gaming/steam.nix
    ../../modules/desktop/gaming/sunshine.nix
  ];

  # users
  users.users."navega" = {
    isNormalUser = true;
    description = "David Navega";
    extraGroups = [
      "wheel"
      "networkmanager"
      "uinput"
    ];
  };

  # autologin
  services.getty.autologinUser = "navega";
  services.getty.autologinOnce = false;
  services.getty.greetingLine = "";
  services.getty.helpLine = "";
  services.xserver.displayManager.startx = {
    enable = true;
    generateScript = true;
  };

  environment.loginShellInit = ''
    if [ "$(tty)" = "/dev/tty1" ] && [ -z "$DISPLAY" ]; then
      exec startx >/dev/null 2>&1
    fi
  '';
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  environment.enableAllTerminfo = true;
  system.stateVersion = "26.05";

}
