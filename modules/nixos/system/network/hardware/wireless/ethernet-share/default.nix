{ config, ... }:
let
  hostName = config.networking.hostName;
  # Fixed alias for whatever physical ethernet NIC is plugged in, so the
  # rest of this module never has to name a specific bus-path-derived
  # interface (e.g. "enp109s0") that shifts with docks/BIOS/hardware.
  iface = "share0";
in
{
  # Internet + LAN sharing: this laptop stays on wifi (wlan0, managed by
  # iwd) and shares that uplink out over the ethernet port to the desktop
  # plugged into it. No NetworkManager or systemd-networkd here, just plain
  # dhcpcd, so the shared interface needs a static address and its own
  # DHCP/DNS server.

  # udev renames the real ethernet NIC to a stable "share0" on device add,
  # matched by driver rather than bus path/PCI slot so it survives docking
  # changes or a different board entirely. r8169 is the wired NIC driver;
  # wlan0 (iwlwifi/ath/etc.) and podman's veth pairs never match it.
  # Requires the interface to be (re)enumerated -- a reboot -- to take
  # effect, since udev won't rename a live, already-up interface.
  systemd.network.links."10-${iface}" = {
    matchConfig.Driver = "r8169";
    linkConfig.Name = iface;
  };

  networking.interfaces.${iface} = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.66.1";
        prefixLength = 24;
      }
    ];
  };

  # NAT module also flips on net.ipv4.conf.all.forwarding and adds the
  # FORWARD rules between externalInterface <-> internalInterfaces.
  networking.nat = {
    enable = true;
    externalInterface = "wlan0";
    internalInterfaces = [ iface ];
  };

  # dnsmasq is both the DHCP server for the desktop and the local DNS that
  # lets the two boxes find each other by name: it auto-registers whatever
  # hostname the desktop sends via DHCP under *.lan, and this laptop gets a
  # matching host-record so the lookup works in both directions.
  #
  # network-addresses-<iface>.service is only started when the underlying
  # .device unit (re)appears, which doesn't happen on a live `switch` if the
  # NIC was already up beforehand -- pull it in explicitly so dnsmasq always
  # has the static 192.168.66.1 address to bind to, on every start.
  systemd.services.dnsmasq = {
    after = [ "network-addresses-${iface}.service" ];
    wants = [ "network-addresses-${iface}.service" ];
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [
        iface
        "lo"
      ];
      bind-interfaces = true; # otherwise it grabs :53 on every interface,
      # fighting resolved's 127.0.0.53 stub
      domain = "lan";
      expand-hosts = true;
      local = "/lan/"; # never forward *.lan queries upstream
      host-record = [ "${hostName},${hostName}.lan,192.168.66.1" ];
      dhcp-range = [ "192.168.66.10,192.168.66.250,255.255.255.0,12h" ];
      dhcp-option = [
        "option:router,192.168.66.1"
        "option:dns-server,192.168.66.1"
      ];
      server = [
        "1.1.1.1"
        "9.9.9.9"
      ]; # upstream resolvers, matches tailscale.nix
    };
  };

  # NOTE: the laptop does not resolve the desktop's *.lan name itself (only
  # the desktop, via the DHCP-provided 192.168.66.1 DNS server, does). A
  # prior attempt routed ~lan queries to dnsmasq via a global
  # services.resolved.settings.Resolve.DNS override, but a global DNS=
  # isn't actually scoped to its Domains= the way a per-link one is --
  # systemd-resolved picked 127.0.0.1 as the system-wide default resolver,
  # which broke hostname resolution (router DNS, Tailscale MagicDNS) for
  # everything else, including SSH to other machines. Reach the desktop
  # from the laptop via 192.168.66.x instead.

  # small trusted point-to-point link to a single known desktop: skip
  # per-port firewall bookkeeping so whatever sharing tool gets used later
  # (SMB, syncthing, rsync...) just works.
  networking.firewall.trustedInterfaces = [ iface ];
}
