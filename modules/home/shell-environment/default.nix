# The terminal environment, identical on every machine.
#
# Everything here is OS-agnostic: verified to evaluate under home-manager for
# both x86_64-linux and aarch64-darwin, and every stylix target used below
# exists on both platforms. Nothing in this tree needs a platform guard.
#
# One flat list rather than a default.nix per category, so the whole environment
# is readable at a glance.
_: {
  imports = [
    ./shell/bash
    ./shell/readline
    ./shell/zsh
    ./shell/fish
    ./prompt/starship
    ./history/atuin
    ./text-editor/helix
    ./version-control/git
    ./file-manager/yazi
    ./multiplexer/tmux
    ./multiplexer/zellij
    ./packages
  ];
}
