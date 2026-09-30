{ config, lib, ... }:
let
  cfg = config.my.shellCommands;
in {

  # One definition, three shells. Any module under shell-environment/ that
  # wants a shortcut declares it here instead of repeating the fan-out at the
  # bottom of this file:
  #
  #   my.shellCommands.ll = "eza -l --icons";
  #
  # The module system merges these attribute sets across every module that
  # sets them, so each concern declares only its own shortcuts and none of
  # them has to know the others exist. Two modules claiming the same name is
  # an eval error rather than a silent last-one-wins, which is what you want:
  # it is the only way to notice that `navigation` and `file-transfer` have
  # both decided they own `ll`.
  options.my.shellCommands = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    example = {
      ll = "eza -l --icons";
      gs = "git status --short";
    };
    description = ''
      Shell shortcuts defined once for every interactive shell in this
      configuration. bash and zsh receive them as aliases; fish receives them
      as abbreviations.
    '';
  };

  config = {
    # fish gets abbreviations rather than aliases deliberately. An
    # abbreviation expands into the command line before it runs, so the real
    # command is visible and editable at the point of use -- worth having for
    # anything destructive, and the reason `rsync-mirror` is safe to define
    # at all: you see the --delete before you press enter.
    programs.fish.shellAbbrs = cfg;
    programs.bash.shellAliases = cfg;
    programs.zsh.shellAliases = cfg;
  };
}
