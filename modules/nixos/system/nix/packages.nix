{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixd
    nil
    nixfmt
    nixfmt-tree
    alejandra
    statix
    deadnix
    nix-tree
    nix-du
    nvd
    manix
    nurl
    nix-output-monitor
  ];
}
