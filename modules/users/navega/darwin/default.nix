{ pkgs, ... }:
{

  users.users.navega = {
    name = "navega";
    home = "/Users/navega";
  };
  system.primaryUser = "navega";

  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  environment.shells = with pkgs; [ bash zsh fish ];

}
