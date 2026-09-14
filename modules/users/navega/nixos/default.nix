{ pkgs, ... }:
{
  users.users."navega" = {
    isNormalUser = true;
    uid = 1000;
    description = "David Navega";
    extraGroups = [
      "networkmanager"
      "wheel"
      "uinput"
    ];

    shell = pkgs.fish;
  };

  # The one piece of the shell that cannot live in home-manager. Home-manager's
  # programs.fish only writes ~/.config/fish; it cannot register fish in
  # /etc/shells or give it the system PATH. NixOS asserts the two go together --
  # setting the shell without this fails the build with "might make logging in
  # as that user impossible" (config/users-groups.nix).
  #
  # This is account plumbing, not terminal configuration: everything you
  # actually interact with is in modules/home/shell-environment.
  programs.fish.enable = true;
}
