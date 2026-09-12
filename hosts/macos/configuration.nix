{ self, ... }:

{
  imports = [
    # darwin layer -- macOS system defaults (dock, finder, trackpad)
    "${self}/modules/darwin/macos"
    # host layer -- home-manager
    ./modules/home-manager
    # host layer -- homebrew (nix-homebrew + cask/brew set)
    ./modules/homebrew
    # host layer -- stylix theming
    ./modules/stylix

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
