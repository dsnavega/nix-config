{ ... }:
{
  imports = [
    ./shell/bash
    ./shell/readline
    ./shell/zsh
    ./shell/fish
    ./prompt/starship
    ./history/atuin
    ./multiplexer/tmux
    ./multiplexer/zellij
    ./text-editor/helix
    ./file-manager/yazi
    ./version-control/git
    ./packages
    ./artificial-intelligence
  ];
}
