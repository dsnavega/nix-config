{ self, ... }:
{
  imports = [ "${self}/home-manager" ];
  home-manager.users.navega.imports = [
    # navega on every host: identity, stateVersion
    "${self}/home-manager/users/navega"
    # profile for this host
    "${self}/home-manager/users/navega/profiles/headless"
  ];
}
