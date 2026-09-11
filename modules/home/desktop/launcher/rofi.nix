{ config, lib, pkgs, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
  iconTheme =
    if config.stylix.polarity == "dark" then config.stylix.icons.dark else config.stylix.icons.light;
in
{
  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-file-browser ];
    font = lib.mkForce "${config.stylix.fonts.monospace.name} 28";
    extraConfig = {
      modi = "drun,run,window,ssh,filebrowser";
      show-icons = true;
      terminal = "alacritty";
      icon-theme = iconTheme;

      sidebar-mode = true;
      display-drun = "󰀻 Apps: ";
      display-run = " Run: ";
      display-window = " Window: ";
      display-ssh = "󰣀 SSH: ";
      display-filebrowser = " Files: ";

      kb-element-next = "";
      kb-element-prev = "";
      kb-mode-next = "Tab";
      kb-mode-previous = "ISO_Left_Tab";
    };

    theme = {
      window = {
        width = mkLiteral "100%";
        height = mkLiteral "100%";
      };

      "mode-switcher" = {
        spacing = mkLiteral "8px";
      };

      button = {
        padding = mkLiteral "8px 12px";
        border = mkLiteral "0px 0px 2px 0px";
        border-color = mkLiteral "@separatorcolor";
      };
      "button selected" = {
        background-color = lib.mkForce (mkLiteral "@selected-active-background");
        text-color = lib.mkForce (mkLiteral "@selected-active-foreground");
        border-color = mkLiteral "@selected-active-background";
      };
    };
  };

  stylix.targets.rofi.enable = true;
}
