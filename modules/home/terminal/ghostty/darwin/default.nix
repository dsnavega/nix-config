# Ghostty on macOS. Counterpart to ../nixos.
#
# The app itself is a Homebrew cask (hosts/macos/modules/homebrew), so
# home-manager writes the config only. Font and colours come from stylix
# (hosts/macos/modules/stylix), exactly as on NixOS.
{ ... }:
{
  programs.ghostty = {
    enable = true;
    package = null;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    settings = {
      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;
      window-save-state = "always";
      auto-update = "off";
      macos-titlebar-style = "tabs";
      macos-option-as-alt = "left";
      mouse-hide-while-typing = true;
      # quick-terminal-position = "center";
      # keybind = [ "global:ctrl+period=toggle_quick_terminal" ];
    };
  };
}
