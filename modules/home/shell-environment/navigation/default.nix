{ pkgs, ... }:
{

  my.shellCommands = {
    # eza: a listing that sorts directories first and carries icons. `ls` is
    # shadowed on purpose -- eza is the one that should be reached for.
    ls = "eza --icons --group-directories-first";
    ll = "eza -l --icons --group-directories-first";
    la = "eza -la --icons --group-directories-first";
    lt = "eza --tree --level=2 --icons";

    # zoxide: `cd` learns the directories actually visited and jumps to them
    # by fragment, so `cd conf` reaches nix-config from anywhere.
    cd = "z";
    cdi = "zi";
    z = "zoxide query";
    zi = "zoxide query -i";
    zl = "zoxide query --list";
    zr = "zoxide remove";
  };

  # programs
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    # Atuin owns Ctrl-R (history/atuin); fzf keeps Ctrl-T and Alt-C.
    historyWidget.command = "";
  };

  # packages
  home.packages = with pkgs; [
    eza
  ];

  # variables
  home.sessionVariables = {
    _ZO_ANCHOR = "1";
    _ZO_MAX_DB_SIZE = "10000";
    _ZO_RESOLVE_SYMLINKS = "1";
  };

}
