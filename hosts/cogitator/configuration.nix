{ ... }:
{

  imports = [
    # host layer -- boot, system (hardware), home-manager, stylix (theme)
    ./modules/boot
    ./modules/system
    ./modules/home-manager
    ./modules/stylix

    # system layer -- users
    ../../modules/users/navega/nixos

    # system layer -- nix, environment, locale, security, diagnostics
    ../../modules/nix/nixos
    ../../modules/nixos/system/environment
    ../../modules/nixos/system/locale
    ../../modules/nixos/system/security
    ../../modules/nixos/system/diagnostics

    # system layer -- network (hardware, services)
    ../../modules/nixos/system/network/hardware/networkmanager
    ../../modules/nixos/system/network/services/openssh
    ../../modules/nixos/system/network/services/mosh
    ../../modules/nixos/system/network/services/tailscale
    ../../modules/nixos/system/network/services/avahi
    ../../modules/nixos/system/network/services/atuin

    # system layer -- virtualisation (podman, distrobox)
    ../../modules/nixos/system/virtualisation

    # system layer -- packages
    ../../modules/nixos/system/packages/hardware
    ../../modules/nixos/system/packages/command-line-interface
  ];

}
