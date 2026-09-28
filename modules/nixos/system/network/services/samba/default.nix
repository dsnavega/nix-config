# SMB file server. The shares on /srv (spinning disk) and /home/navega (SSD)
# are reachable from every machine in the tailnet.
#
# SMB rather than NFS for one reason: a trash. NFS unlink is immediate and
# unrecoverable, and macOS Finder will not even offer Trash on an NFS mount --
# it warns the item is deleted immediately. Samba's recycle VFS module moves
# deletions into <share>/.recycle instead, server side, for any client. Both
# filesystems here are ext4, so there are no snapshots to fall back on and this
# is the only safety net short of a backup tool.
#
# Note what recycle does not cover: deletions made locally on this host, and
# applications that truncate a file in place. It is not a backup.
{ ... }:
let

  user = "navega";
  group = "users"; # NixOS default group for isNormalUser

  # Shared settings for every share: writable by navega only, with a recycle bin.
  mkShare =
    path: extra:
    {
      inherit path;

      "browseable" = "yes";
      "read only" = "no";
      "valid users" = user;
      "force user" = user;
      "force group" = group;
      "create mask" = "0644";
      "directory mask" = "0755";

      # catia, fruit and streams_xattr are the macOS interop chain and have to
      # appear in that order -- fruit wraps streams_xattr. recycle follows.
      "vfs objects" = "catia fruit streams_xattr recycle";

      # touch=yes rewrites mtime as the file is moved into .recycle, which is
      # what makes the age-based tmpfiles rule below expire the right things:
      # 30 days after deletion, not 30 days after the file was last edited.
      "recycle:repository" = ".recycle";
      "recycle:keeptree" = "yes";
      "recycle:versions" = "yes";
      "recycle:touch" = "yes";
      "recycle:maxsize" = 0;
      "recycle:exclude" = "*.tmp|*.temp|*.o|*.obj|~$*|.DS_Store";
      "recycle:exclude_dir" = ".recycle|/tmp|/cache";
    }
    // extra;

  # One line per share. /srv is the dedicated spinning disk, /home is the SSD.
  shares = {
    documents = mkShare "/srv/samba/documents" { };
    media = mkShare "/srv/samba/media" { };
    archive = mkShare "/srv/samba/archive" { };
    home = mkShare "/home/navega" {
      # The account owns these either way, but there is no reason to put them
      # on the wire. delete veto files=no keeps rmdir from reaching into them.
      "veto files" = "/.ssh/.gnupg/";
      "delete veto files" = "no";
    };
  };

in
{

  services.samba = {
    enable = true;

    # No firewall hole is opened: the firewall already trusts tailscale0
    # (see ../tailscale), so only tailnet peers reach smbd. Same arrangement as
    # the atuin server in ../atuin.
    #
    # Deliberately not setting `bind interfaces only` on top of this -- smbd
    # would race tailscale0 coming up and fail to bind at boot.
    openFirewall = false;

    # NetBIOS name service and browsing are Windows-era and unused here; macOS
    # finds this host through MagicDNS.
    nmbd.enable = false;
    winbindd.enable = false;

    settings = {
      global = {
        "server string" = "cogitator";
        "workgroup" = "WORKGROUP";

        # A real Samba user, not guest. One `smbpasswd -a navega` on this host,
        # stored in /var/lib/samba/private/passdb.tdb and kept out of git;
        # macOS saves it to the Keychain on first connect and stops asking.
        # Keeping a named user is also what leaves per-share `valid users`
        # available as the share set grows.
        "security" = "user";
        "map to guest" = "never";

        "server min protocol" = "SMB3";

        # Off on purpose. The traffic only ever travels inside the tailnet,
        # which is already WireGuard, so SMB3 encryption would buy nothing and
        # cost throughput on the SSD share.
        "server smb encrypt" = "off";

        # Defense in depth behind the firewall: the Tailscale CGNAT range and
        # the Tailscale IPv6 ULA prefix, nothing else.
        "hosts allow" = "100.64.0.0/10 fd7a:115c:a1e0::/48 127.0.0.1 ::1";
        "hosts deny" = "0.0.0.0/0";

        "load printers" = "no";
        "printing" = "bsd";
        "printcap name" = "/dev/null";
        "disable spoolss" = "yes";

        "logging" = "systemd";

        # macOS interop: resource forks, Finder metadata and POSIX rename.
        "fruit:aapl" = "yes";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:nfs_aces" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
      };
    }
    // shares;
  };

  # Share roots, plus expiry for the recycle bins. systemd-tmpfiles-clean.timer
  # runs daily; `e` applies the age to an existing directory's contents and
  # does nothing if the directory is not there yet.
  systemd.tmpfiles.rules = [
    "d /srv/samba           0755 ${user} ${group} -"
    "d /srv/samba/documents 0755 ${user} ${group} -"
    "d /srv/samba/media     0755 ${user} ${group} -"
    "d /srv/samba/archive   0755 ${user} ${group} -"

    "e /srv/samba/documents/.recycle - - - 30d"
    "e /srv/samba/media/.recycle     - - - 30d"
    "e /srv/samba/archive/.recycle   - - - 30d"
    "e /home/navega/.recycle         - - - 30d"
  ];

}
