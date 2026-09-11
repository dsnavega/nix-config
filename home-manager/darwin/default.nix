# nix-darwin-level home-manager wiring.
#
# Counterpart to ../nixos: the home-manager darwin module is declared in
# flake.nix, this only configures it. The option set is currently identical to
# the NixOS side -- kept as a separate file because that is where the two are
# expected to diverge (launchd integration, /Users paths, no useUserPackages).
#
# Unused until a darwin host exists in flake.nix.
{ inputs, self, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs self; };
  };
}
