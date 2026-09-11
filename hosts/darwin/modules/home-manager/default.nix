{ self, ... }:
{
  imports = [ "${self}/home-manager/darwin" ];

  home-manager.users.navega =
    import "${self}/home-manager/users/navega/profiles/headless";
}
