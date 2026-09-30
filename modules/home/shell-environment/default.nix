{ ... }:
{
  imports = [
    ./shell/bash
    ./shell/readline
    ./shell/zsh
    ./shell/fish
    ./shell/commands
    ./prompt/starship
    ./history/atuin
    ./multiplexer/tmux
    ./multiplexer/zellij
    ./text-editor/helix
    ./file-manager/yazi
    ./version-control/git
    ./navigation
    ./file-transfer
    ./system-update
    ./core-utils
    ./artificial-intelligence
    ./development/python
  ];
}
