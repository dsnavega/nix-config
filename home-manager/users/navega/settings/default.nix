# Who navega is, on any platform. Imported by every navega profile.
#
# Only identity and home-manager self-management belong here. NixOS/darwin-level
# options (useGlobalPkgs, backupFileExtension, ...) are a different module system
# and live in ../../../nixos and ../../../darwin.
{ pkgs, ... }:
{
  home.username = "navega";
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/navega" else "/home/navega";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
