{ pkgs, ... }:
let
  # Stylix multiplies these sizes by 4/3 for Ghostty and Zed on macOS, to match
  # Linux's 96 DPI against macOS's 72. Write the size you actually want on
  # screen, in macOS points, and undo that scaling here.
  points = size: size * 3.0 / 4.0;
in
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font Mono";
      };

      # macOS system fonts. They ship with the OS, so there is nothing for nix to
      # install; stylix still requires a package, hence the empty one. SF Pro and
      # New York are private system fonts that apps cannot select by name, so
      # these are the closest native families that are.
      sansSerif = {
        package = pkgs.emptyDirectory;
        name = "Helvetica Neue";
      };
      serif = {
        package = pkgs.emptyDirectory;
        name = "Charter";
      };
      emoji = {
        package = pkgs.emptyDirectory;
        name = "Apple Color Emoji";
      };

      sizes = {
        terminal = points 14; # Ghostty, and Zed's editor buffer
        applications = points 15; # Zed's UI
        desktop = 13;
        popups = 13;
      };
    };

  };
}
