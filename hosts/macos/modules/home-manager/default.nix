{ self, ... }:
{
  imports = [ "${self}/home-manager" ];
  home-manager.users.navega =
    import "${self}/home-manager/users/navega/profiles/headless";
}
