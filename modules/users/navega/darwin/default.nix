{ pkgs, ... }:
{
  # The account already exists on macOS; nix-darwin only needs to know about it.
  users.users.navega = {
    name = "navega";
    home = "/Users/navega";
  };
  system.primaryUser = "navega";

  # The login shell (dscl UserShell) is /run/current-system/sw/bin/fish. Only
  # this puts fish at that path -- home-manager's programs.fish installs to
  # /etc/profiles/per-user/navega/bin instead. Without it, anything that spawns
  # the login shell (Zed's terminal, ssh) fails.
  programs.fish.enable = true;

  # Unlike NixOS, enabling fish does not register it; this writes /etc/shells
  # (macOS defaults are kept, fish is appended).
  environment.shells = [ pkgs.fish ];
}
