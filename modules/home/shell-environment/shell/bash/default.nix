{ ... }:
{
  # Not the daily driver, but it is the fallback shell, what a stray script
  # lands in, and what you get on a machine before any of this is applied -- so
  # it is worth making genuinely pleasant rather than merely present.
  #
  # Completion of *system* packages also needs /share/bash-completion linked
  # into the environment; NixOS does that already via programs.bash.completion.
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [
      "ignoredups"
      "ignorespace" # a leading space keeps a command out of history
    ];
    historySize = 10000;
    historyFileSize = 100000;
    historyIgnore = [
      "ls"
      "ll"
      "la"
      "cd"
      "exit"
      "clear"
      "history"
    ];

    # Setting this replaces home-manager's default list rather than extending
    # it, so the four it ships with are restated first.
    shellOptions = [
      # home-manager defaults
      "histappend" # append to the history file instead of overwriting it
      "extglob" # extended globbing
      "globstar" # ** matches across directories
      "checkjobs" # warn before exiting with running jobs

      # additions
      "checkwinsize" # keep $LINES/$COLUMNS right after a resize
      "cmdhist" # keep a multi-line command as one history entry
      "autocd" # a bare directory name means cd into it
      "cdspell" # fix small typos in cd arguments
      "dirspell" # and in directory names during completion
      "no_empty_cmd_completion" # do not scan $PATH when the line is empty
    ];
  };
}
