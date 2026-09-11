{ config, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  services.flameshot = {
    enable = true;
    settings.General = {
      uiColor = colors.base0D;
      contrastUiColor = colors.base02;
      drawColor = colors.base08;
      contrastOpacity = 192;
      disabledTrayIcon = true;
      showStartupLaunchMessage = false;
      showHelp = true;
      saveAsFileExtension = "png";
      savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
      # Both hosts are X11-only (i3, no Wayland) but strix has no display
      # manager (manual startx), so systemd-logind never learns the session
      # is graphical and stays registered as XDG_SESSION_TYPE=tty. Flameshot
      # then times out trying the portal-based screenshot path instead of
      # falling back to native X11 capture. This skips the portal entirely.
      useX11LegacyScreenshot = true;
    };
  };
}
