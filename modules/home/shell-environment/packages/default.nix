{ pkgs, ... }:
let

  flake = "$HOME/nix-config";

  rebuilder =
    if pkgs.stdenv.hostPlatform.isDarwin then "darwin-rebuild" else "nixos-rebuild";

  # Nix reads a flake through git, so a file that exists on disk but is not in
  # the index is invisible to the build:
  #
  #   error: Path 'modules/darwin' does not exist in Git repository
  #
  # `git add -N` registers the path without staging its content -- enough for
  # nix to see the file, while `git status` and `git commit` behave as before.
  # Every rebuild alias below runs this first so a freshly created module is
  # never silently skipped.
  track = "git -C ${flake} add -AN --";

  commands = {
    # eza shortcuts
    ls = "eza --icons --group-directories-first";
    ll = "eza -l --icons --group-directories-first";
    la = "eza -la --icons --group-directories-first";
    lt = "eza --tree --level=2 --icons";

    # zoxide shortcuts
    cd = "z";
    cdi = "zi";
    z = "zoxide query";
    zi = "zoxide query -i";
    zl = "zoxide query --list";
    zr = "zoxide remove";

    # rebuild: evaluate, build and activate. Needs sudo.
    rebuild = "${track} && sudo ${rebuilder} switch --flake ${flake}";

    # rebuild-test: evaluate and build, but do not activate. No sudo, so this
    # is the loop to use while editing modules -- it catches every eval error
    # and every build failure that `rebuild` would.
    rebuild-test = "${track} && ${rebuilder} build --flake ${flake}";

    # rebuild-eval: evaluate only. Fastest check that the module tree still
    # wires up -- catches bad import paths without building anything.
    rebuild-eval = "${track} && ${rebuilder} build --flake ${flake} --dry-run";

    # rebuild-update: refresh flake inputs, then activate.
    rebuild-update =
      "${track} && nix flake update --flake ${flake} && sudo ${rebuilder} switch --flake ${flake}";
  };

in {

  # set aliases and abbreviations
  programs.fish.shellAbbrs = commands;
  programs.bash.shellAliases = commands;
  programs.zsh.shellAliases = commands;

  # packages
  home.packages = with pkgs; [
    eza
    bat
    fd
    ripgrep
    jq
    yq-go
    tree
  ];

  # zoxide
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.fzf.enable = true;

  home.sessionVariables = {
    # zoxide
    _ZO_ANCHOR = "1";
    _ZO_MAX_DB_SIZE = "10000";
    _ZO_RESOLVE_SYMLINKS = "1";
  };

}
