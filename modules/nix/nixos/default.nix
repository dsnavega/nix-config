{ ... }:
{
  imports = [
    ../common
    ./nix-ld
    ../packages
  ];
  documentation.nixos.enable = true;
  nix.gc.dates = "weekly";
  nixpkgs.config.cudaSupport = true;
  nix.settings = {
    extra-substituters = [
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
}
