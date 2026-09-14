# Nix daemon settings shared by NixOS and nix-darwin.
#
# Not imported by hosts directly -- import ./nixos or ./darwin, which pull this
# in and add the handful of options that only exist on their platform.
#
# What can live here, and what cannot:
#
#   * Everything under `nix.settings` is a freeform attrset written straight
#     out to nix.conf, so it is safe to share wholesale.
#   * Options that exist on BOTH module systems can be set here, using
#     `pkgs.stdenv.hostPlatform.isDarwin` to pick a VALUE.
#   * Options whose NAME differs between the two cannot be handled here, and
#     are left to the importing platform file. `lib.mkIf` does NOT help: the
#     module system rejects a definition for an undeclared option regardless
#     of the condition. There are exactly two such cases today:
#       - nix.gc.dates (NixOS) vs nix.gc.interval (darwin) -- nix-darwin
#         asserts if `dates` is set
#       - documentation.nixos.enable (NixOS only)
#
# Note also that the platform test must only ever choose a VALUE, never which
# keys this module defines. Deciding keys from `pkgs` while the module also
# sets `nixpkgs.config` is circular and evaluates to infinite recursion.
{ pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{

  nixpkgs.config.allowUnfree = true;
  documentation.man.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      max-jobs = "auto";
      cores = 0;

      trusted-users = [ (if isDarwin then "@admin" else "@wheel") ];

      keep-outputs = true;
      keep-derivations = true;
      warn-dirty = false;

      auto-optimise-store = !isDarwin;

      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.numtide.com"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };
}
