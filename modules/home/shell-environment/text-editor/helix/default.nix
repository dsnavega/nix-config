{ ... }:
{
  programs.helix = {
    enable = true;
    # Sets EDITOR and VISUAL from the package that is actually installed, rather
    # than hand-writing them in the profile and hoping helix is on PATH.
    defaultEditor = true;
  };
}
