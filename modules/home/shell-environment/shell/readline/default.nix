{ ... }:
{
  # Where bash's line editing actually lives. Worth knowing: this writes
  # ~/.inputrc, which is read by *every* readline program -- bash, the python
  # REPL, psql, sqlite3, gdb -- not just bash. That is a feature here (the same
  # editing behaviour everywhere) but it is why this is its own module and not
  # part of shell/bash.
  programs.readline = {
    enable = true;

    variables = {
      completion-ignore-case = true;
      completion-map-case = true; # treat - and _ as interchangeable
      show-all-if-ambiguous = true; # one Tab lists matches instead of two
      show-all-if-unmodified = true;
      menu-complete-display-prefix = true;
      colored-stats = true; # colour completions by file type
      colored-completion-prefix = true;
      mark-symlinked-directories = true;
      skip-completed-text = true; # no duplicated text when completing mid-word
      revert-all-at-newline = true;
      completion-query-items = 200;
      bell-style = "none";
    };

    bindings = {
      # Prefix search on Up/Down: type a few characters, then Up walks only the
      # history entries starting with them. This is what fish does natively and
      # what atuin's --disable-up-arrow leaves room for elsewhere, so all three
      # shells behave the same way.
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";

      # Ctrl-Left / Ctrl-Right move by word.
      "\\e[1;5C" = "forward-word";
      "\\e[1;5D" = "backward-word";
    };
  };
}
