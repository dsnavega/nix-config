# Atuin sync server. Shell history from every machine syncs here over Tailscale.
#
# History is end-to-end encrypted by each client with the account key before it
# is uploaded; this server only ever stores ciphertext. Transport is plain HTTP,
# which is fine because it only travels inside the tailnet (WireGuard).
{ ... }:
{
  services.atuin = {
    enable = true;
    # Listen on all interfaces, but no firewall hole is opened: the firewall
    # already trusts tailscale0 (see ../tailscale), so only tailnet peers reach it.
    host = "0.0.0.0";
    port = 8888;
    openFirewall = false;
    # Needed once, to create the account. After `atuin register` succeeds,
    # set this to false and redeploy.
    openRegistration = true;
    # Postgres on this host, created and owned by the module.
    database.createLocally = true;
  };
}
