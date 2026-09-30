# SMB file server
# The shares are reachable from every machine in the tailnet.
# SMB rather than NFS for one reason: a trash. Samba's recycle VFS module moves
# deletions into <share>/.recycle instead, server side, for any client.
{ ... }:
let

  user = "navega";
  group = "users"; # NixOS default group for isNormalUser

  # Shared settings for every share: writable by user only, with a recycle bin.
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
      #macOS:
      "vfs objects" = "catia fruit streams_xattr recycle";

      # recycle
      "recycle:repository" = ".recycle";
      "recycle:keeptree" = "yes";
      "recycle:versions" = "yes";
      "recycle:touch" = "yes";
      "recycle:maxsize" = 0;
      "recycle:exclude" = "*.tmp|*.temp|*.o|*.obj|~$*|.DS_Store";
      "recycle:exclude_dir" = ".recycle|/tmp|/cache";
    }
    // extra;

  # shares:
  shares = {
    documents = mkShare "/srv/samba/documents" { };
    media = mkShare "/srv/samba/media" { };
    archive = mkShare "/srv/samba/archive" { };
    home = mkShare "/home/navega" {
      "veto files" = "/.ssh/.gnupg/";
      "delete veto files" = "no";
    };
  };

in
{

  services.samba = {
    enable = true;
    openFirewall = false;
    nmbd.enable = false;
    winbindd.enable = false;

    settings = {
      global = {
        "server string" = "cogitator";
        "workgroup" = "WORKGROUP";
        "security" = "user";
        "map to guest" = "never";
        "server min protocol" = "SMB3";
        "server smb encrypt" = "off";
        "hosts allow" = "100.64.0.0/10 fd7a:115c:a1e0::/48 127.0.0.1 ::1";
        "hosts deny" = "0.0.0.0/0";
        "load printers" = "no";
        "printing" = "bsd";
        "printcap name" = "/dev/null";
        "disable spoolss" = "yes";
        "logging" = "systemd";
        # macOS: resource forks, Finder metadata and POSIX rename.
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
