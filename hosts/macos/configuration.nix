{ self, ... }:

{
  imports = [
    # darwin layer -- nix-darwin module: macOS system defaults (dock, finder, trackpad)
    "${self}/modules/darwin"
    # host layer -- home-manager
    ./modules/home-manager
    # host layer -- homebrew (nix-homebrew + cask/brew set)
    ./modules/homebrew
    # host layer -- stylix theming
    ./modules/stylix

  ];

  # darwin specific user
  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.navega = {
    name = "navega";
    home = "/Users/navega";
  };
  system.primaryUser = "navega";
  system.stateVersion = 6;

}
