{ ... }:
{
  # Deliberately thin -- zellij is the one with real configuration. tmux is here
  # because it is what remote machines and other people's docs assume.
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
  };
}
