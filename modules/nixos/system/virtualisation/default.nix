{ pkgs, ... }:
{

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman
    podman-compose
    podman-tui
    distrobox
    distrobox-tui
  ];

}
