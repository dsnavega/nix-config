{ ... }:
{
  programs.zed-editor = {
    enable = true;
    package = null;
  };

  stylix.targets.zed = {
    enable = true;
    colors.enable = true;
    fonts.enable = true;
  };
}
