{ pkgs, ... }:
{
  programs.mosh.enable = true;
  programs.mosh.withUtempter = true;
  programs.mosh.package = pkgs.mosh;
}
