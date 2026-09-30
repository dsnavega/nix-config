{ pkgs, lib, ... }:
let

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  flake = "$HOME/nix-config";

  rebuilder = if isDarwin then "darwin-rebuild" else "nixos-rebuild";

  # Nix reads a flake through git, so a file that exists on disk but is not in
  # the index is invisible to the build:
  #
  #   error: Path 'modules/darwin' does not exist in Git repository
  #
  # `git add -N` registers the path without staging its content -- enough for
  # nix to see the file, while `git status` and `git commit` behave as before.
  # Every command below runs this first so a freshly created module is never
  # silently skipped.
  track = "git -C ${flake} add -AN --";

  # The two halves of "make this machine current", kept separate so the third
  # command can be their composition rather than a third copy. Composing here
  # rather than defining update-all as "update-brew && update-nix" is
  # deliberate: bash would expand that nested alias, but fish abbreviations do
  # not expand recursively, so the fish version would look for a binary named
  # update-brew and fail.
  nixUpdate =
    "${track} && nix flake update --flake ${flake} && sudo ${rebuilder} switch --flake ${flake}";

  # Casks that set `auto_updates true` -- ghostty, zed, obsidian, firefox and
  # most of the others -- are skipped by `brew upgrade` on purpose, because
  # they update themselves. Add --greedy here if you would rather brew drive
  # those too, at the cost of re-downloading apps that had already updated.
  brewUpdate = "brew update && brew upgrade && brew cleanup";

in {

  my.shellCommands = {

    # --- apply the configuration as written -------------------------------

    # rebuild: evaluate, build and activate. Needs sudo. Idempotent now that
    # homebrew no longer upgrades during activation (see the homebrew module
    # in hosts/macos): running it twice is a no-op rather than a surprise
    # round of cask upgrades in the middle of an unrelated module edit.
    rebuild = "${track} && sudo ${rebuilder} switch --flake ${flake}";

    # rebuild-test: evaluate and build, but do not activate. No sudo, so this
    # is the loop to use while editing modules -- it catches every eval error
    # and every build failure that `rebuild` would.
    rebuild-test = "${track} && ${rebuilder} build --flake ${flake}";

    # rebuild-eval: evaluate only. Fastest check that the module tree still
    # wires up -- catches bad import paths without building anything.
    rebuild-eval = "${track} && ${rebuilder} build --flake ${flake} --dry-run";

    # --- pull newer versions from upstream --------------------------------

    # update-nix: refresh flake inputs, then activate. Everything nix owns.
    update-nix = nixUpdate;

  } // lib.optionalAttrs isDarwin {

    # update-brew: everything homebrew owns. Upgrading is imperative by
    # nature -- which versions you land on depends on when you run it -- so
    # it lives behind its own command instead of riding along with every
    # activation.
    update-brew = brewUpdate;

    # update-all: both, homebrew first so that the activation's `brew bundle`
    # has the last word on what is installed. Darwin only; on NixOS,
    # update-nix already is everything.
    update-all = "${brewUpdate} && ${nixUpdate}";
  };

}
