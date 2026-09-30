{ pkgs, ... }:
let

  # Every transfer command below writes a per-run log under XDG state, named
  # after the moment it started. rsync and rclone both abort when the
  # --log-file directory is missing, so each one mkdir -p's it first -- that
  # keeps them working on a fresh machine and after the logs are hand-cleaned,
  # without a stray .keep file in the tree.
  #
  # The log deliberately stays here rather than travelling with the data. A
  # manifest written into the transferred tree collides with rsync's own
  # model: the copies on either end necessarily differ, so a mirror run
  # overwrites the destination's record with the source's, and --dry-run
  # never reports a clean tree again. `rsync-check` answers "is the
  # destination in the state I expect" without any of that.
  rsyncLogs = "$HOME/.local/state/rsync";
  rcloneLogs = "$HOME/.local/state/rclone";
  stamp = "$(date +%Y%m%d-%H%M%S)";

  # --info=progress2 reports one percentage for the whole transfer instead of
  # a bar per file, and needs rsync >= 3.1: the nixpkgs rsync below, NOT the
  # openrsync that macOS ships as /usr/bin/rsync (protocol 29, no --info at
  # all). If these start failing, check that `which rsync` still resolves into
  # the nix profile.
  #
  # --partial keeps a half-written file on the destination so an interrupted
  # run resumes it rather than starting that file from zero.
  #
  # -z is safe to leave on unconditionally here, which is not the advice you
  # will find written down. Between two rsyncs at 3.2 or newer it negotiates
  # zstd (confirm with --debug=NSTR: "negotiated compress: zstd (level 3)"),
  # and zstd detects incompressible input and passes it through -- measured on
  # this machine at 3.5 GB/s with a 1.00x ratio on random data, so a photo or
  # video library pays nothing for the flag. The old "never -z media" rule is
  # about zlib, which manages 73 MB/s on the same data: below gigabit, so it
  # really would throttle a LAN copy.
  #
  # The fallback is the thing to watch, not the flag. A peer without zstd
  # (an appliance NAS, macOS's own openrsync) silently drops to that 73 MB/s
  # zlib path. It stays invisible over Tailscale, where the link is slower
  # than zlib anyway, and costs real throughput over gigabit ethernet. Left
  # as plain -z rather than --zc=zstd on purpose: pinning the algorithm turns
  # that degradation into a hard error against those same peers.
  #
  # --log-file comes last so the paths the caller appends stay after every
  # option, which is also where the fish abbreviation leaves the cursor.
  rsyncBase = "mkdir -p ${rsyncLogs} && rsync -ahz --partial --info=progress2"
    + " --stats --log-file=${rsyncLogs}/${stamp}.log";

  # rclone draws --progress over stderr, so a log on the terminal fights the
  # live display for the same lines; --log-file sends the record to disk and
  # leaves the progress meter intact. INFO is the level that names every file
  # transferred -- the default NOTICE only records problems.
  rcloneBase = subcommand:
    "mkdir -p ${rcloneLogs} && rclone ${subcommand} --progress --stats=1s"
    + " --transfers=8 --checkers=16 --create-empty-src-dirs --log-level=INFO"
    + " --log-file=${rcloneLogs}/${stamp}.log";

in {

  # Each command takes the same arguments as the tool it wraps, so the
  # trailing SRC DST is all that is left to type:
  #
  #   rsync-copy ~/Pictures/ nas:/srv/media/pictures/
  #   rclone-copy ~/Pictures gdrive:pictures
  #
  # In fish these arrive as abbreviations, so the whole command is spelled out
  # in the buffer before it runs -- add --dry-run to a mirror, or drop a flag,
  # while looking at exactly what is about to happen.
  my.shellCommands = {

    # Copy, leaving anything already at the destination alone. Note rsync's
    # trailing-slash rule -- `src/` copies the contents of src, `src` copies
    # the directory itself.
    rsync-copy = rsyncBase;

    # Copy, then unlink each file from the source once its transfer is
    # verified. Empty source directories are left behind.
    rsync-move = "${rsyncBase} --remove-source-files";

    # Make the destination match the source exactly. Destructive: --delete
    # removes anything at the destination that is not in the source, so read
    # the expansion before pressing enter.
    rsync-mirror = "${rsyncBase} --delete";

    # What a copy would change, writing nothing and logging nothing.
    # --itemize-changes prints a per-file reason code for each difference.
    rsync-check = "rsync -ah --dry-run --itemize-changes --stats";

    # The same three verbs against any rclone remote. rclone's own `sync` is
    # the mirroring one, so it lands under -mirror for symmetry with rsync
    # rather than under its own name.
    rclone-copy = rcloneBase "copy";
    rclone-move = "${rcloneBase "move"} --delete-empty-src-dirs";
    rclone-mirror = rcloneBase "sync";

    # Compare both ends by size and hash, changing neither.
    rclone-check = "rclone check --progress";

    # The logs themselves, newest first.
    rsync-logs = "mkdir -p ${rsyncLogs} && eza -l --sort=modified --reverse ${rsyncLogs}";
    rclone-logs = "mkdir -p ${rcloneLogs} && eza -l --sort=modified --reverse ${rcloneLogs}";
  };

  # eza is also declared by navigation/; home.packages is a list, and
  # identical derivations collapse in the profile. Each module naming what its
  # own commands reach for is worth the duplicate entry.
  home.packages = with pkgs; [
    rsync
    rclone
    eza
  ];

}
