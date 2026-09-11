{ ... }:

{
  imports = [
    # host layer -- home-manager
    ./modules/home-manager
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # nix-darwin needs the user declared before home-manager can manage it.
  users.users.navega = {
    name = "navega";
    home = "/Users/navega";
  };

  system.primaryUser = "navega";
  system.stateVersion = 6;
}
