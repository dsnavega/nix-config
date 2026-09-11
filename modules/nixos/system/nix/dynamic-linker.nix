{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libGL
      glib
      zlib
      stdenv.cc.cc.lib
      openssl
    ];
  };
}
