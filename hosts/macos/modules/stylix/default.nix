{ pkgs, ... }:
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
        # 13pt is the macOS default body text size.
        applications = 13;
        desktop = 13;
        popups = 13;
        terminal = 14;
      };
    };

  };
}
