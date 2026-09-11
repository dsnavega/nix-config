# LAYER 2 -- the graphical session.
#
# Only the plumbing every desktop needs. The display manager and the window
# manager are choices, not defaults, so a host imports those itself:
#
#   ../../modules/nixos/desktop
#   ../../modules/nixos/desktop/display-manager/ly
#   ../../modules/nixos/desktop/window-manager/i3
#
# A headless host skips this layer entirely and never pulls the font closure.
_: {
  imports = [
    ./services
    ./fonts
  ];
}
