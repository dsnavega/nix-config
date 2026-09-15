{ pkgs, ...}: {
  home.packages = with pkgs.numtide; [
    claude-code
    opencode
    hermes-agent
  ];
}
