{ ... }:
{
  programs.zellij = {
    enable = true;
  };

  # Deliberately no `stylix.targets.zellij.enable`. Stylix turns that target on
  # by itself whenever programs.zellij.enable is true, so setting it here only
  # ever hurt: it made this module hard-require the stylix module, which broke
  # every host that does not load one -- cogitator omits stylix on purpose,
  # being headless with nothing to theme.
}
