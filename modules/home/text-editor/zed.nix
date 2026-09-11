{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
  };

  # opencode-desktop hardcodes `spawn zed` for "Open in Zed",
  # but nixpkgs names the binary `zeditor` — provide a `zed` shim.
  home.packages = [
    (pkgs.writeShellScriptBin "zed" ''
      exec ${pkgs.zed-editor}/bin/zeditor "$@"
    '')
  ];
  stylix.targets.zed = {
    enable = true;
    colors.enable = true;
    fonts.enable = true;
  };
}
