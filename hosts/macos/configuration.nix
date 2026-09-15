{ self, ... }:

{
  imports = [
    # shared layer -- the navega account (NixOS and darwin)
    "${self}/modules/users/navega/darwin"
    # darwin layer -- nix daemon settings (flakes, caches, gc)
    "${self}/modules/nix/darwin"
    # shared layer -- sudo (password feedback, timeout)
    "${self}/modules/sudo"
    # darwin layer -- macOS system defaults (dock, finder, trackpad)
    ./modules/darwin
    # system layer -- home-manager
    ./modules/home-manager
    # system layer -- homebrew (nix-homebrew + cask/brew set)
    ./modules/homebrew
    # system layer -- stylix theming
    ./modules/stylix
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
