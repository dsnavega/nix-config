{inputs, ... }: {
  home.username = "navega";
  home.homeDirectory = "/home/navega";
  home.stateVersion = "26.05";
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.backupFileExtension = "backup";
  programs.home-manager.enable = true;
}
