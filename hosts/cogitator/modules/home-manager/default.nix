{ self, ... }:
{
  imports = [ "${self}/home-manager/nixos" ];
  home-manager.users.navega =
    import "${self}/home-manager/users/navega/profiles/headless";
}
