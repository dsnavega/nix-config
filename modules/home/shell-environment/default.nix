{ ... }:
{
  imports = [
    ./shell/readline
    ./shell/bash
    ./shell/zsh
    ./shell/fish
    ./shell/commands
    ./navigation
    ./file-transfer
    ./system-update
    ./nix-store
    ./prompt/starship
    ./history/atuin
    ./multiplexer/tmux
    ./multiplexer/zellij
    ./text-editor/helix
    ./file-manager/yazi
    ./version-control/git
    ./core-utils
    ./artificial-intelligence
    ./development/python
  ];
}
