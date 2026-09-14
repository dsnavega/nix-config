{ ... }:
{
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
      window-decoration = "server";
      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;
    };
  };
}
