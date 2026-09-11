{ ... }:
{

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  documentation.nixos.enable = true;
  documentation.man.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;

      trusted-users = [
        "root"
        "@wheel"
      ];

      keep-outputs = true;
      keep-derivations = true;
      warn-dirty = false;

      substituters = [
        "https://cache.nixos.org"
        "https://cache.nixos-cuda.org"
        "https://nix-community.cachix.org"

      ];

      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];

    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;

  };

}
