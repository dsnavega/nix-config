{ pkgs, ... }:
{

  programs.home-manager.enable = true;
  home.stateVersion = "26.05";

  home.username = "navega";
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/navega"
    else "/home/navega";

}
