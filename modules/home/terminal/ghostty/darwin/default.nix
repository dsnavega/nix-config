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
      # --- shared with ../nixos --------------------------------------------
      # (window-decoration = "server" is GTK-only; macOS always draws natively.)
      window-padding-x = 8;
      window-padding-y = 8;
      window-padding-balance = true;

      # --- macOS ---------------------------------------------------------------
      # Left Option sends Alt, so Alt bindings work in helix, zellij and fish.
      # Right Option keeps its macOS role of typing accents and symbols (é ç €).
      macos-option-as-alt = "left";

      # Homebrew (onActivation.upgrade) owns updates; keep Ghostty's built-in
      # Sparkle updater from racing it and leaving brew's version out of date.
      auto-update = "off";

      # Tabs live in the titlebar, like Safari and Finder.
      macos-titlebar-style = "tabs";

      # Reopen windows, tabs and splits after quitting, like other macOS apps.
      window-save-state = "always";

      mouse-hide-while-typing = true;

      # Quick terminal: a drop-down terminal toggled from any app. `global:`
      # keybinds need Ghostty to be granted Accessibility access (System
      # Settings > Privacy & Security). Ctrl rather than Cmd, because Cmd+`
      # is the system shortcut for cycling an app's windows.
      quick-terminal-position = "top";
      keybind = [ "global:ctrl+grave_accent=toggle_quick_terminal" ];
    };
  };
}
