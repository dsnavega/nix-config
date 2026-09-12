# NixOS-level home-manager wiring.
#
# The home-manager NixOS module itself is declared in flake.nix; this file only
# configures it. Hosts import this, then assign profiles to users:
#
#   imports = [ "${self}/home-manager/nixos" ];
#   home-manager.users.navega =
#     import "${self}/home-manager/users/navega/profiles/headless";
{ inputs, self, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "old";
    extraSpecialArgs = { inherit inputs self; };
  };
}
