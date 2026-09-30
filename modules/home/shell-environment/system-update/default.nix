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

  # The attribute name of this machine under darwinConfigurations in flake.nix.
  # Only `rebuild-brew` needs it: darwin-rebuild finds the current host by
  # itself, but a bare `nix eval` has to be told which configuration to read.
  darwinHost = "macos";

in {

  # On darwin, homebrew is upgraded by activation rather than by a command of
  # its own: hosts/macos/modules/homebrew sets onActivation.autoUpdate and
  # .upgrade, so every `brew bundle` run during a switch does `brew update &&
  # brew upgrade` as well as installing what is declared. Two consequences
  # worth knowing, because neither is visible from here:
  #
  #   - `rebuild` is not idempotent on darwin. It applies the configuration
  #     and upgrades homebrew packages in the same step, so which cask
  #     versions you land on depends on when you ran it.
  #   - there is no separate brew command, and `update-all` really does mean
  #     all: a dedicated one would only repeat what the switch already did.
  my.shellCommands = {

    # rebuild: evaluate, build and activate the configuration as written.
    # Needs sudo.
    rebuild = "${track} && sudo ${rebuilder} switch --flake ${flake}";

    # rebuild-test: evaluate and build, but do not activate. No sudo, so this
    # is the loop to use while editing modules -- it catches every eval error
    # and every build failure that `rebuild` would, and leaves homebrew alone
    # because nothing is activated.
    rebuild-test = "${track} && ${rebuilder} build --flake ${flake}";

    # rebuild-eval: evaluate only. Fastest check that the module tree still
    # wires up -- catches bad import paths without building anything.
    rebuild-eval = "${track} && ${rebuilder} build --flake ${flake} --dry-run";

    # update-all: move everything forward. Refreshes the flake inputs, then
    # activates -- which on darwin also carries homebrew along. This is the
    # one to reach for periodically; `rebuild` is the one for applying an edit
    # you just made.
    update-all =
      "${track} && nix flake update --flake ${flake} && sudo ${rebuilder} switch --flake ${flake}";

  } // lib.optionalAttrs isDarwin {

    # rebuild-brew: install what homebrew.casks/brews/taps declares, without
    # building or activating anything else. For the common case of adding one
    # cask to the config and wanting it on disk now.
    #
    # It works because `homebrew.brewfile` is a plain string option -- the
    # module renders the Brewfile during evaluation, so reading it needs no
    # system build at all (about a tenth of a second warm) and `brew bundle`
    # takes it on stdin via --file=-. No temp file, and no sudo: activation
    # only uses sudo to drop from root back to this user.
    #
    # Deliberately narrower than the homebrew half of a real switch:
    #
    #   --no-upgrade      installs what is missing and leaves the versions of
    #                     everything else alone, so adding a cask cannot drag
    #                     in a round of unrelated upgrades.
    #   no --zap          activation passes --zap --force-cleanup, which
    #                     removes anything not in the Brewfile along with its
    #                     data. Adding a cask should not be able to delete
    #                     one, so pruning waits for the next `rebuild`.
    #
    # Auto-update is left on: it refreshes homebrew's API cache, which is how
    # a cask added to the config today is found at all.
    rebuild-brew = "${track} && nix eval --raw"
      + " ${flake}#darwinConfigurations.${darwinHost}.config.homebrew.brewfile"
      + " | brew bundle install --file=- --no-upgrade";

    # rebuild-home: activate the home-manager half only -- shell config,
    # dotfiles, user packages, LaunchAgents. This is the fast loop for edits
    # under modules/home, which is where most of them land: the generated
    # activate script contains no reference to brew and needs no sudo, so it
    # cannot stall on a pending cask upgrade the way a full switch can.
    #
    # $USER rather than a second hardcoded name: it has to match the attribute
    # under home-manager.users, which it does on this machine.
    #
    # Darwin only, deliberately. On NixOS `nixos-rebuild switch` never carries
    # homebrew along, so there is nothing to carve out -- the reason this slice
    # exists is a macOS-specific one.
    #
    # System-level changes still need `rebuild`: darwin defaults, homebrew,
    # anything under launchd at the system level.
    #
    # --out-link to a fixed path, rather than substituting the built path into
    # command position. Two forms that look obvious do not survive all three
    # shells: fish rejects $(...)/activate outright ("command substitutions
    # not allowed in command position"), and `xargs -I% %/activate` only
    # substitutes % in arguments, never in the utility name, so it tries to
    # exec a file literally called %. A fixed path needs no substitution, and
    # && short-circuits cleanly when the build fails.
    #
    # The out-link is also a GC root, which keeps the generation alive between
    # the build and the activation.
    rebuild-home = "${track} && nix build --out-link $TMPDIR/hm-generation"
      + " ${flake}#darwinConfigurations.${darwinHost}.config.home-manager"
      + ".users.$USER.home.activationPackage && $TMPDIR/hm-generation/activate";
  };

}
