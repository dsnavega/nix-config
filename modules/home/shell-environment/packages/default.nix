{ pkgs, ... }:
let

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

    # nixos-rebuild and darwin-rebuild
    rebuild =
      if pkgs.stdenv.hostPlatform.isDarwin then
        "sudo darwin-rebuild switch --flake ~/nix-config"
      else
        "sudo nixos-rebuild switch --flake ~/nix-config";
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
