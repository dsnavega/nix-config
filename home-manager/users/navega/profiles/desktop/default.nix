# Desktop: the headless terminal environment plus a KDE/Qt graphical session.
{ self, pkgs, ... }:
{
  imports = [
    ../headless

    "${self}/modules/home/desktop"
    "${self}/modules/home/browser/firefox.nix"
    "${self}/modules/home/browser/chromium.nix"
    "${self}/modules/home/terminal/alacritty.nix"
    "${self}/modules/home/terminal/ghostty/nixos"
    "${self}/modules/home/text-editor/zed.nix"
    "${self}/modules/home/text-editor/obsidian.nix"
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    TERMINAL = "alacritty";
    QT_QUICK_CONTROLS_STYLE = "org.kde.desktop";
    XDG_CURRENT_DESKTOP = "KDE";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };

  xdg.mime.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [ "kde" ];
      };
    };
  };
}
