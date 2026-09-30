{ pkgs, ... }:
{

  # The utilities every other module assumes are simply present: better
  # defaults for reading, finding and filtering. Nothing here needs
  # configuration, which is why it stays one list rather than six modules.
  home.packages = with pkgs; [
    bat
    fd
    ripgrep
    jq
    yq-go
    tree
  ];

}
