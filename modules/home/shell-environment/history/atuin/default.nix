{ ... }:
{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    settings = {
        style = "compact";
        inline_height = 20;
        show_help = true;
        show_tabs = true;
    };
    flags = [ "--disable-up-arrow" ];
  };
}
