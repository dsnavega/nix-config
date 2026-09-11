{ pkgs, ... }:

{

  # imports
  imports = [
    # host-specific
    ../zenbook/modules/boot
    ../zenbook/modules/system
    ../zenbook/modules/stylix
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
    ../../modules/core/virtualisation
    ../../modules/core/locale
    ../../modules/core/fonts
    ../../modules/core/development
    ../../modules/core/artificial-intelligence
    ../../modules/core/power-management
    ../../modules/desktop/services
    ../../modules/desktop/window-manager/i3
    ../../modules/desktop/display-manager/ly
  ];

  # users
  users.users."navega" = {
    isNormalUser = true;
    description = "David Navega";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
    shellAbbrs = {
      nrs = "sudo nixos-rebuild switch";
    };
  };

  environment.enableAllTerminfo = true;
  system.stateVersion = "26.05";

}
