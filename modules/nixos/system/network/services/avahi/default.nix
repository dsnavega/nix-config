{ config, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;

    # Bare hostname only. Avahi appends the mDNS domain (default "local")
    # itself, so setting this to "cogitator.local" would publish as
    # "cogitator.local.local" instead of the intended "cogitator.local".
    hostName = config.networking.hostName;

    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
