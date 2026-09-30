{ ... }:
let

  # The two profiles that pin store paths on this machine. A generation is a
  # GC root, so nothing in its closure can ever be collected while it exists:
  # reclaiming real space is almost always a matter of deleting generations
  # first and collecting second, which is what the commands below do in that
  # order.
  #
  # The system profile is root-owned -- even listing it needs sudo, because
  # nix takes a lock on it.
  systemProfile = "/nix/var/nix/profiles/system";
  homeProfile = "$HOME/.local/state/nix/profiles/home-manager";

  # How much history to keep by default. Old generations are the rollback
  # safety net, so the everyday command keeps a week of them and the
  # scorched-earth one is spelled out separately.
  keep = "7d";

  collect = "nix-collect-garbage";

in {

  my.shellCommands = {

    # --- look before deleting ----------------------------------------------

    # store-gens: what is currently pinning the store, newest last. Usually
    # the answer to "why is /nix so large" -- a machine that has been rebuilt
    # for months accumulates one full system closure per generation.
    store-gens = "nix-env --list-generations --profile ${homeProfile}"
      + " && sudo nix-env --list-generations --profile ${systemProfile}";

    # store-dead: how much is collectable right now, without touching any
    # generation. Read-only. Takes a while -- it walks the whole store to
    # determine reachability.
    store-dead = "nix store gc --dry-run";

    # store-roots: which GC roots keep a given path alive. Reach for this when
    # a collection frees nothing and it is not obvious what is holding on:
    #
    #   store-roots /nix/store/...-some-package
    store-roots = "nix-store --query --roots";

    # --- reclaim ------------------------------------------------------------

    # store-gc: the everyday one. Deletes generations older than ${keep} and
    # then collects what is no longer reachable. Run twice over, because a
    # user invocation can only prune the profiles it owns: the first pass
    # takes home-manager, the second the system profile.
    #
    # The current generation is never deleted, whatever its age.
    store-gc = "${collect} --delete-older-than ${keep}"
      + " && sudo ${collect} --delete-older-than ${keep}";

    # store-gc-all: keep only the current generation of each profile, delete
    # every other one, then collect. Frees the most and gives up rollback
    # entirely -- after this there is no older system to return to.
    store-gc-all = "${collect} --delete-old && sudo ${collect} --delete-old";

    # store-optimise: find files that are identical across store paths and
    # replace the duplicates with hard links. Reclaims space without deleting
    # anything, so it is safe at any time, but it is slow on a large store and
    # only worth running after a collection.
    store-optimise = "nix store optimise";
  };

}
