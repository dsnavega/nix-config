{ config, ... }:
{
  services.tailscale.enable = true;
  services.tailscale.extraUpFlags = [ "--accept-dns=true" ];

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ config.services.tailscale.interfaceName ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };

  services.resolved.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

}
