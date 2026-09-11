{ lib, ... }:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      window-decoration = "server";
#       font-size = lib.mkForce 18;
      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;
    };
    
  };
}
